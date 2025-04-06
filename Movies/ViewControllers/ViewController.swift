//
//  ViewController.swift
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

final class ViewController: UIViewController {
    // MARK: - Private Properties
    private let headers = [
        "x-rapidapi-key": "9f2de86b9dmsh83f8d1376e73079p1b96bejsn8083da56f624",
        "x-rapidapi-host": "imdb236.p.rapidapi.com"
    ]
    private let requestMostPopularMovies = NSMutableURLRequest(
        url: Link.mostPopularMovies.url,
        cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 10.0
    )
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestMostPopularMovies.httpMethod = "GET"
        requestMostPopularMovies.allHTTPHeaderFields = headers
        
//        getMostPopularMovies()
        testing()
    }

    @IBAction private func actionButton() {
        print("This is an action button")
    }


}
// MARK: - Networking
private extension ViewController {
    func getMostPopularMovies() {
        URLSession.shared
            .dataTask(with: requestMostPopularMovies as URLRequest) {
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
                
                if response.statusCode == 200 {
                    do {
                        let mostPopularMovies = try decoder.decode(
                            MostPopularMovies.self,
                            from: data
                        )
                        showAlert(withStatus: .succes)
                        mostPopularMovies.data.forEach { print($0) }
                        DispatchQueue.main.async {
                            self.view.backgroundColor = .green
                        }
                        print("STATUS CODE: \(response.statusCode)")
                    } catch let error {
                        showAlert(withStatus: .failed)
                        print("STATUS CODE: \(response.statusCode)")
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
                guard let self else {
                    print("Cant do testing")
                    return
                }
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
private extension ViewController {
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
