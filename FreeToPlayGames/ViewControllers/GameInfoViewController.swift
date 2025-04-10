//
//  GameInfoViewController.swift
//  FreeToPlayGames
//
//  Created by Denis Lachikhin on 10.04.2025.
//

import UIKit

final class GameInfoViewController: UIViewController {
    // MARK: - Private IB Outlets
    @IBOutlet private var gameThumbnaillImageView: UIImageView! {
        didSet {
            gameThumbnaillImageView.layer.cornerRadius = 20
        }
    }
    @IBOutlet private var gameDescriptionLabel: UILabel!
    @IBOutlet private var gameInfoLabel: UILabel!
    
    // MARK: - Public Properties
    var theGame: Game!
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameInfoScreen()
    }
    
    // MARK: - Privat IB Actions
    @IBAction private func websiteDidPressed() {
        
    }
    @IBAction func freeToPlayDidPressed() {
    }
    
    // MARK: - Private Methods
    private func setupGameInfoScreen() {
        fetchImage(from: theGame.thumbnail) { [weak self] image in
            guard let self else { return }
            gameThumbnaillImageView.image = image
        }
        
        navigationItem.title = theGame.title
        gameDescriptionLabel.text = theGame.shortDescription
        gameInfoLabel.text = theGame.about
    }
}

// MARK: - Networking
private extension GameInfoViewController {
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
