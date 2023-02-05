//
//  MovieCategory.swift
//  TestMovie
//
//  Created by Tung Phan on 28/01/2023.
//

import Foundation

// MARK: - MovieCategory
struct MovieCategory: Codable {
    let id: Int
    let name: String
}

// MARK: - MovieCategoryGenres

struct MovieCategoryGenres: Codable {
    let genres: [MovieCategory]
}
