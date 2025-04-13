//
//  Extension + UIViewController.swift
//  FreeToPlayGames
//
//  Created by Denis Lachikhin on 13.04.2025.
//

import UIKit

extension UIViewController {
    enum UnavailableMessageType {
        case loading
        case downloadError
        
        var imageName: String {
            switch self {
            case .loading:
                "loading"
            case .downloadError:
                "x.circle"
            }
        }
    }
    
    func showUnavailableMessage(
        _ message: String,
        withConfig config: UIContentUnavailableConfiguration,
        image: UnavailableMessageType? = nil,
        andColor color: UIColor
    ) {
        var config = config
        config.text = message
        config.textProperties.color = color
        config.textProperties.font = .boldSystemFont(ofSize: 20)
        if let image {
            config.image = UIImage(named: image.imageName)
            config.imageProperties.maximumSize.height = 100
        }
        contentUnavailableConfiguration = config
    }
}
