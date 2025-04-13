//
//  GamesListViewController.swift
//  FreeToPlayGames
//
//  Created by Denis Lachikhin on 06.04.2025.
//

import UIKit

final class GamesListViewController: UITableViewController {
    // MARK: - Private Properties
    private var freeGamesList: [Game] = []
    private let networkManager = NetworkManager.shared
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        showUnavailableMessage(
            "Pleas wait...",
            withConfig: UIContentUnavailableConfiguration.loading(),
            image: .loading,
            andColor: .systemBlue
        )
        fetchGamesList()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameInfoVC = segue.destination as? GameInfoViewController
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        gameInfoVC?.game = freeGamesList[indexPath.row]
    }
    
    // MARK: - Private Methods
    private func sortGamesByTitle() {
        freeGamesList.sort { $0.title < $1.title}
    }
    private func fixLowercasedLetters() {
        var gameModel: Game?
        
        freeGamesList.forEach { game in
            var title = game.title.compactMap { $0 }
            var newTitleName = ""
            gameModel = game
            
            if ((title.first?.lowercased()) != nil) {
                let firstLetter = title.removeFirst()
                title.insert(contentsOf: firstLetter.uppercased(), at: 0)
                title.forEach {newTitleName += String($0) }
                
                freeGamesList.removeAll { gameId in
                    gameId.id == game.id
                }
            }
            
            guard var gameModel else { return }
            gameModel.title = newTitleName
            freeGamesList.append(gameModel)
        }
    }
    private func fetchImage(from url: URL, completion: @escaping (UIImage) -> Void) {
        networkManager.fetchImage(from: url) {[weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else {
                    showUnavailableMessage(
                        "Decoding error",
                        withConfig: UIContentUnavailableConfiguration.empty(),
                        image: .downloadError,
                        andColor: .systemRed
                    )
                    return
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            case .failure(let error):
                showUnavailableMessage(
                    error.localizedDescription,
                    withConfig: UIContentUnavailableConfiguration.empty(),
                    image: .downloadError,
                    andColor: .systemRed
                )
            }
        }
    }
    func fetchGamesList() {
        networkManager
            .fetchFreeToPlayGamesList(from: freeToPlayGamesURL) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let games):
                    freeGamesList = games
                    fixLowercasedLetters()
                    sortGamesByTitle()
                    activityItemsConfiguration = nil
                    tableView.reloadData()
                case .failure(let error):
                    showUnavailableMessage(
                        error.localizedDescription,
                        withConfig: UIContentUnavailableConfiguration.empty(),
                        image: .downloadError,
                        andColor: .systemRed
                    )
                }
            }
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
        let theGame = freeGamesList[indexPath.row]
        cellSetup(cell, with: theGame)
        contentUnavailableConfiguration = nil
        return cell
    }
}

// MARK: - Setup UI
private extension GamesListViewController {
    func cellSetup(_ cell: UITableViewCell, with game: Game) {
        var content = cell.defaultContentConfiguration()
        
        content.text = game.title
        content.textProperties.alignment = .justified
        content.textProperties.font = .boldSystemFont(ofSize: 18)
        
        cell.contentConfiguration = content
        
        fetchImage(from: game.thumbnail) { imageData in
            content.image = imageData
            content.imageProperties.cornerRadius = 10
            content.imageProperties.maximumSize.height = 60
            
            cell.contentConfiguration = content
        }
    }
}


