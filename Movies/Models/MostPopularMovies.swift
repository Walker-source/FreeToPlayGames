//
//  MostPopularMovies.swift
//  Movies
//
//  Created by Denis Lachikhin on 06.04.2025.
//

import Foundation

struct MostPopularMovies: Decodable {
    let data: [Movie]
}

struct Movie: Decodable {
    let id: Int
    let primaryTitle: String
    let type: String
    let description: String
    let primaryImage: String
    let startYear: Int
    let releaseDate: String
    let interests: [String]
    let countriesOfOrigin: [String]
    let spokenLanguages: [String]
    let genres: [String]
    let runtimeMinutes: Int
    let averageRating: Int
    let numVotes: Int
}
