//
//  MovieModel.swift
//  TestMovie
//
//  Created by Tung Phan on 28/01/2023.
//

import Foundation

// MARK: - MovieList
struct MovieList: Codable {
    let dates: Dates?
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String
}

// MARK: - Movie
struct Movie: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String?
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension Movie: MovieData {
    func getId() -> String {
        return "\(self.id)"
    }
    
    func getBackdropPath() -> String {
        return self.backdropPath ?? ""
    }
    
    func getOverview() -> String {
        return self.overview
    }
    
    func getPosterPath() -> String {
        return self.posterPath ?? ""
    }
    
    func getReleaseDate() -> String {
        return self.releaseDate ?? ""
    }
    
    func getTitle() -> String {
        return self.title ?? ""
    }
    
    func getVoteCount() -> String {
        return "\(self.voteCount)"
    }
    
    func getVoteAverage() -> String {
        return "\(self.voteAverage)"
    }
    
    func getGenresId() -> String {
        return ""
    }
    
    func getIsFavorite() -> Bool {
        return true
    }
    
}
