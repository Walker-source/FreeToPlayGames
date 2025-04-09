//
//  Testing.swift
//  Movies
//
//  Created by Denis Lachikhin on 06.04.2025.
//

import Foundation

struct Testing: Decodable {
    let data: [Person]
}

struct Person: Decodable {
    let id: Int
    let first_name: String
    let last_name: String
}
