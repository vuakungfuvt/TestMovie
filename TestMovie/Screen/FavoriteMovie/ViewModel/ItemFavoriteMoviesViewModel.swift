//
//  ItemFavoriteMoviesViewModel.swift
//  TestMovie
//
//  Created by Tung Phan on 03/02/2023.
//

import UIKit

struct ItemFavoriteMoviesViewModel {
    let averageVote: String
    let voteCount: String
    let posterPath: String?
    let title: String?
    let genresName: String?
    let releasedDate: String?
    let isFavorite: Bool
    
    init(model: MovieLocal) {
        self.averageVote = "\(model.voteAverage)"
        self.voteCount = "\(model.voteCount)"
        self.posterPath = model.posterPath
        self.title = model.title
        self.genresName = ""
        self.releasedDate = model.releaseDate
        self.isFavorite = model.isFavorite
    }
    
}
