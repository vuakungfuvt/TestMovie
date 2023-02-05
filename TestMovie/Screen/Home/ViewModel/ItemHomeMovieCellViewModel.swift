//
//  ItemHomeMovieCellViewModel.swift
//  TestMovie
//
//  Created by Tung Phan on 03/02/2023.
//

import Foundation

struct ItemHomeMovieCellViewModel {
    
    var backdropPath: String?
    var genresName: String?
    var overview: String
    var posterPath, releaseDate, title: String?
    var voteAverage: Double
    var voteCount: Int
    var isFavorite: Bool
    
    init(movie: Movie) {
        self.backdropPath = movie.backdropPath
        let genreIds = movie.genreIDS
        var movieGenres = [MovieCategory]()
        for genreId in genreIds {
            if let movie = GlobalVariables.shared.movieCategories.first(where: { $0.id == genreId }) {
                movieGenres.append(movie)
            }
        }
        let genresName = movieGenres.compactMap { $0.name }.joined(separator: ", ")
        self.genresName = genresName
        self.overview = movie.overview
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
        self.title = movie.title
        self.voteAverage = movie.voteAverage
        self.voteCount = movie.voteCount
        self.isFavorite = GlobalVariables.shared.favoriteMovies[movie.getId()] ?? false
    }
}
