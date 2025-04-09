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
    
     var freeGamesList: [Game] = []
    var countCells = 0
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
//        getFreeToPlayGames { [weak self] game in
//            guard let self else { return }
//            freeGamesList = game
//        }
        print(freeGamesList.isEmpty)
    }
}

extension GamesListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        freeGamesList.count
//        countCells
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
            cell.contentConfiguration = content
        }
        
        return cell
    }
}

// MARK: - Networking
private extension GamesListViewController {
//    func getFreeToPlayGames(completion: @escaping ([Game]) -> Void) {
//        URLSession.shared
//            .dataTask(with: gamesUrl) {
//                [weak self] data,
//                _,
//                error in
//                guard let self else { return }
//                
//                guard let data else {
//                    print(error?.localizedDescription ?? "No error description")
//                    return
//                }
//                
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                
//                do {
//                    let games = try decoder.decode([Game].self, from: data)
//                    //                        showAlert(withStatus: .succes)
//                    games.forEach { print($0) }
//                    
//                    DispatchQueue.main.async {
//                        completion(games)
//                    }
//                } catch let error {
//                    showAlert(withStatus: .failed)
//                    print(error)
//                }
//            }.resume()
//    }

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


