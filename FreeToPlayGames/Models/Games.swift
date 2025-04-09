//
//  Games.swift
//  Movies
//
//  Created by Denis Lachikhin on 09.04.2025.
//

import Foundation

struct Game: Decodable {
    let id: Int
    let title: String
    let thumbnail: URL
    let shortDescription: String
    let gameUrl: URL
    let genre: String
    let platform: String
    let publisher: String
    let developer: String
    let releaseDate: String
    let freetogameProfileUrl: URL
}
