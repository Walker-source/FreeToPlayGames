//
//  MainScreen.swift
//  Movies
//
//  Created by Denis Lachikhin on 06.04.2025.
//

import UIKit

enum Link {
    case mostPopularMovies
    case testing
    
    var url: URL {
        switch self {
        case .mostPopularMovies:
            URL(string: "https://imdb236.p.rapidapi.com/imdb/most-popular-movies")!
        case .testing:
            URL(string: "https://reqres.in/api/users?page=2")!
        }
    }
}
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

final class MainScreen: UIViewController {
    // MARK: - Private Properties
    private let gamesUrl = URL(string:"https://www.freetogame.com/api/games?platform=pc")!
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFreeToPlayGames()
//        testing()
    }
}

// MARK: - Networking
private extension MainScreen {
    func getFreeToPlayGames() {
        URLSession.shared
            .dataTask(with: gamesUrl) {
                [weak self] data,
                response,
                error in
                guard let self else {
                    print("Cant get most popular movies")
                    return }
                guard let data,
                      let response = response as? HTTPURLResponse else {
                    print(error?.localizedDescription ?? "No error description")
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if response.statusCode == 200 {
                    do {
                        let mostPopularMovies = try decoder.decode([Game].self, from: data)
                        showAlert(withStatus: .succes)
                        mostPopularMovies.forEach { print($0) }
                        DispatchQueue.main.async {
                            self.view.backgroundColor = .green
                        }
                    } catch let error {
                        showAlert(withStatus: .failed)
                        print(error)
                        DispatchQueue.main.async {
                            self.view.backgroundColor = .red
                        }
                    }
                } else {
                    showAlert(withStatus: .failed)
                    print("STATUS CODE: \(response.statusCode)")
                }
                
            }.resume()
    }
    func testing() {
        URLSession.shared
            .dataTask(with: Link.testing.url) { [weak self] data, _, error in
                guard let self else { return }
                guard let data else {
                    print(error?.localizedDescription ?? "No error description")
                    return
                }
                
                let decoder = JSONDecoder()
                
                do {
                    let mostPopularMovies = try decoder.decode(Testing.self, from: data)
                    showAlert(withStatus: .succes)
                    mostPopularMovies.data.forEach { print($0) }
                    DispatchQueue.main.async {
                        self.view.backgroundColor = .green
                    }
                } catch let error {
                    showAlert(withStatus: .failed)
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.view.backgroundColor = .red
                    }
                }
            }.resume()
    }
}

// MARK: - Internal Methods
private extension MainScreen {
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
