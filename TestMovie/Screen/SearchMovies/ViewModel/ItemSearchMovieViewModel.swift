//
//  ItemSearchMovieViewModel.swift
//  TestMovie
//
//  Created by Tung Phan on 03/02/2023.
//

import UIKit

struct ItemSearchMovieViewModel {
    let averageVote: String
    let voteCount: String
    let posterPath: String?
    let title: String?
    let genresName: String?
    let releasedDate: String?
    let isFavorite: Bool
    
    init(model: Movie) {
        self.averageVote = "\(model.voteAverage)"
        self.voteCount = "\(model.voteCount)"
        self.posterPath = model.posterPath
        self.title = model.title
        let genreIds = model.genreIDS
        var movieGenres = [MovieCategory]()
        for genreId in genreIds {
            if let movie = GlobalVariables.shared.movieCategories.first(where: { $0.id == genreId }) {
                movieGenres.append(movie)
            }
        }
        let genresName = movieGenres.compactMap { $0.name }.joined(separator: ", ")
        self.genresName = "Genres: \(genresName)"
        self.releasedDate = model.releaseDate
        let isFavorite = MovieLocalData.shared.getMovieLocal(id: "\(model.id)")?.isFavorite ?? false
        self.isFavorite = isFavorite
    }
}
