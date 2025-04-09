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
    let thumbnail: String
    let shortDescription: String
    let gameUrl: String
    let genre: String
    let platform: String
    let publisher: String
    let developer: String
    let releaseDate: String
    let freetogameProfileUrl: String
}
