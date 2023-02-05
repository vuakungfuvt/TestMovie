//
//  HomeViewModel.swift
//  TestMovie
//
//  Created by Tung Phan on 28/01/2023.
//

import Foundation

class HomeViewModel {
    
    // MARK: - Variables
    
    var allCategories: [MovieCategory] = []
    let service: MovieDataService
    var showErrorMessage: ((_ message: String) -> Void)?
    private let movieLocalData: MovieLocalData!
    
    init(service: MovieDataService, movieLocalData: MovieLocalData) {
        self.service = service
        self.movieLocalData = movieLocalData
    }
    
    func getAllCategoriesFilm(success: @escaping (([MovieCategory]) -> Void), failure: @escaping ((NetworkServiceError) -> Void)) {
        service.getAllMovieCategories { categories in
            self.allCategories = categories
            GlobalVariables.shared.movieCategories = categories
            success(categories)
        } failure: { error in
            failure(error)
            self.showErrorMessage?(error.localizedDescription)
        }

    }
    
    func updateFavoriteMovie(movie: Movie, isFavorite: Bool) {
        movieLocalData.saveOrUpdate(movie: movie, isFavorite: isFavorite, success: {}) { error in
            
        }
        
        GlobalVariables.shared.favoriteMovies["\(movie.id)"] = isFavorite
    }

}
