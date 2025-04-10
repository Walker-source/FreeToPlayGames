//
//  GamesListViewController.swift
//  FreeToPlayGames
//
//  Created by Denis Lachikhin on 06.04.2025.
//

import UIKit

enum Alert {
    case succes
    case failed
    
    var title: String {
        switch self {
        case .succes:
            "Succes"
        case .failed:
            "Failed"
        }
    }
    var message: String {
        switch self {
        case .succes:
            "You can see the result in the Debug area."
        case .failed:
            "You can see the arror in the Debug area."
        }
    }
}

final class GamesListViewController: UITableViewController {
    // MARK: - Private Properties
    private let gamesUrl = URL(string: "https://www.freetogame.com/api/games?platform=pc")!
    private var freeGamesList: [Game] = []
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
//        getFreeToPlayGames { [weak self] gamesList in
//            guard let self else { return }
//
//            
//            tableView.reloadData()
//        }
        getFreeToPlayGames()
    }
    
//    private func sortGamesByTitle(_ array: [Game]) -> [Game] {
//        var games = array
//        
//        games.sort { $0.title < $1.title}
//        
//        return games
//    }
    
    private func sortGamesByTitle() {
        freeGamesList.sort { $0.title < $1.title}
    }
    
    private func checkForLowercaseLetters(from array: [Game]) -> [Game] {
        var games = array
        var gameModel: Game?
        
        games.forEach { game in
            var title = game.title.compactMap { $0 }
            var newTitleName = ""
            gameModel = game
            
            if ((title.first?.lowercased()) != nil) {
                let firstLetter = title.removeFirst()
                title.insert(contentsOf: firstLetter.uppercased(), at: 0)
                title.forEach {newTitleName += String($0) }
                print(newTitleName)
                games.removeAll { gameId in
                    gameId.id == game.id
                }
            }
            guard var gameModel else { return }
            gameModel.title = newTitleName
            games.append(gameModel)
        }
        
        return games
    }
}

// MARK: - UITableViewDataSource
extension GamesListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        freeGamesList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "gameCell",
            for: indexPath
        )
        
        let gameCell = freeGamesList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = gameCell.title
        content.image = UIImage(systemName: "gamecontroller")
        
        cell.contentConfiguration = content
      
        fetchImage(from: gameCell.thumbnail) { image in
            content.image = image
            content.imageProperties.cornerRadius = 10
            content.imageProperties.maximumSize.height = 60
            content.textProperties.alignment = .justified
            content.textProperties.font = .boldSystemFont(ofSize: 18)
            cell.contentConfiguration = content
        }
        
        return cell
    }
}

// MARK: - Networking
private extension GamesListViewController {
    func getFreeToPlayGames() {
        URLSession.shared
            .dataTask(with: gamesUrl) {
                [weak self] data,
                _,
                error in
                guard let self else { return }
                
                guard let data else {
                    print(error?.localizedDescription ?? "No error description")
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    freeGamesList = try decoder.decode([Game].self, from: data)
                    sortGamesByTitle()
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
                } catch let error {
                    showAlert(withStatus: .failed)
                    print(error)
                }
            }.resume()
    }
    func fetchImage( from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else { return }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}

// MARK: - Internal Methods
private extension GamesListViewController {
    func showAlert(withStatus status: Alert) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(
                title: status.title,
                message: status.message,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self?.present(alert, animated: true)
        }
    }
}


