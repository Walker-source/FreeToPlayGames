//
//  Games.swift
//  Movies
//
//  Created by Denis Lachikhin on 09.04.2025.
//

import Foundation

struct Game: Decodable {
    let id: Int
    var title: String
    let thumbnail: URL
    let shortDescription: String
    let gameUrl: URL
    let genre: String
    let platform: String
    let publisher: String
    let developer: String
    let releaseDate: String
    let freetogameProfileUrl: URL
    
    var about: String {
        """
Genre: \(self.genre).
Platform: \(self.platform).
Publisher: \(self.publisher).
Developer: \(self.developer).
Relseas date: \(self.releaseDate).
"""
    }
}

