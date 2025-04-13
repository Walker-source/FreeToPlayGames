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
    
    // MARK: - Private Properties
    private let networkManeger = NetworkManager.shared
    
    // MARK: - Public Properties
    var game: Game!
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        showUnavailableMessage(
            "Pleas wait...",
            withConfig: UIContentUnavailableConfiguration.loading(),
            image: .loading,
            andColor: .systemBlue
        )
        setupGameInfoScreen()
    }
    
    // MARK: - Privat IB Actions
    @IBAction private func websiteButtonDidPressed() {
        
    }
    @IBAction func freeToPlayButtonDidPressed() {
    }
    
    // MARK: - Private Methods
    private func setupGameInfoScreen() {
        networkManeger.fetchImage(from: game.thumbnail) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let ImageData):
                gameThumbnaillImageView.image = UIImage(data: ImageData)
                contentUnavailableConfiguration = nil
            case .failure(let error):
                gameThumbnaillImageView.image = UIImage(named: "gamecontroller")
                showUnavailableMessage(
                    error.localizedDescription,
                    withConfig: UIContentUnavailableConfiguration.empty(),
                    image: .downloadError,
                    andColor: .systemRed
                )
            }
        }
        
        navigationItem.title = game.title
        gameDescriptionLabel.text = game.shortDescription
        gameInfoLabel.text = game.about
    }
}
