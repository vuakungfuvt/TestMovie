//
//  MovieDetailViewModel.swift
//  TestMovie
//
//  Created by Tung Phan on 29/01/2023.
//

import Foundation

class MovieDetailViewModel {
    
    // MARK: - Variables
    private let service: MovieDataService
    private var movieId: Int
    var movieDetail: MovieDetail?
    var didUpdateFavoriteMovie: ((_ isFavorite: Bool) -> Void)?
    var showErrorMessage: ((_ message: String) -> Void)?
    
    init(movieId: Int, service: MovieDataService) {
        self.movieId = movieId
        self.service = service
        
    }
    
    func getMovieDetail(success: @escaping ((_ movieDetail: MovieDetail) -> Void), failure: @escaping ((_ error: NetworkServiceError) -> Void)) {
        service.getMovieDetail(movieId: self.movieId) { movieDetail in
            self.movieDetail = movieDetail
            success(movieDetail)
        } failure: { error in
            self.showErrorMessage?(error.localizedDescription)
            failure(error)
        }
    }
    
    func getFavorite() -> Bool {
        return MovieLocalData.shared.getMovieLocal(id: "\(movieId)")?.isFavorite ?? false
    }
    
    func setFavorite() {
        let isFavorite = getFavorite()
        guard let movieDetail = self.movieDetail else {
            return
        }
        MovieLocalData.shared.saveOrUpdate(movie: movieDetail, isFavorite: !isFavorite, success: {}, failure: { _ in })
        GlobalVariables.shared.favoriteMovies[movieDetail.getId()] = !isFavorite
        self.didUpdateFavoriteMovie?(!isFavorite)
    }
}
