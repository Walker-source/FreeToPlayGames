//
//  TabBarController.swift
//  FreeToPlayGames
//
//  Created by Denis Lachikhin on 10.04.2025.
//

import UIKit

final class TabBar: UITabBarController {
    private var gamesList: [Game] = []
    private let gamesUrl = URL(string:"https://www.freetogame.com/api/games?platform=pc")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFreeToPlayGames()
    }
    private func setupGamesList() {
        let navigationVC = viewControllers?.first as? UINavigationController
        let gamesListVC = navigationVC?.topViewController as? GamesListViewController
        
        gamesListVC?.freeGamesList = gamesList
    }
}

// MARK: - Networking
private extension TabBar {
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
                    gamesList = try decoder.decode([Game].self, from: data)
                    gamesList.forEach {print($0)}
                } catch let error {
                    print(error)
                }
            }.resume()
    }

}
