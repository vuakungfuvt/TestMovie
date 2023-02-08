//
//  SearchMoviesViewModel.swift
//  TestMovie
//
//  Created by Tung Phan on 31/01/2023.
//

import UIKit

enum SearchCellType {
    case blank
    case movie
    case loadMore
}

class SearchMoviesViewModel {
    
    private let service: MovieDataService
    var movies: [Movie] = []
    private var totalPage: Int = 0
    private var currentPage: Int = 1
    var reloadTableView: (() -> Void)?
    var noticeUpdateFavorite: ((_ isFavorite: Bool) -> Void)?
    var reloadCell: ((_ indexPath: IndexPath, _ isFavorite: Bool) -> Void)?
    var showErrorMessage: ((_ message: String) -> Void)?
    private let movieLocalData: MovieLocalData!
    
    init(service: MovieDataService, movieLocalData: MovieLocalData) {
        self.service = service
        self.movieLocalData = movieLocalData
    }
    
    func searchMovies(key: String, success: @escaping ((_ totalPage: Int, _ movies: [Movie]) -> Void), failure: @escaping ((_ error: NetworkServiceError) -> Void)) {
        service.searchMovies(key: key, page: currentPage) { totalPage, movies in
            self.totalPage = totalPage
            if self.currentPage == 1 {
                self.movies = movies
            } else {
                self.movies += movies
            }
            self.reloadTableView?()
            success(totalPage, movies)
        } failure: { error in
            DispatchQueue.main.async {
                failure(error)
                self.showErrorMessage?(error.localizedDescription)
            }
        }
    }
    
    func getItemCells() -> [SearchCellType] {
        if movies.isEmpty {
            return [.blank]
        }
        var data = [SearchCellType]()
        movies.forEach { _ in data.append(.movie) }
        if currentPage < totalPage {
            data.append(.loadMore)
        }
        return data
    }
    
    func getModel(indexPath: IndexPath) -> Movie {
        return movies[indexPath.row]
    }
    
    func getItemViewModel(indexPath: IndexPath) -> ItemSearchMovieViewModel {
        return ItemSearchMovieViewModel(model: movies[indexPath.row], movieLocalData: movieLocalData)
    }
    
    func refresh(key: String) {
        self.currentPage = 1
        self.searchMovies(key: key) { _, _ in
            
        } failure: { _ in
            
        }

    }
    
    func loadMore(key: String) {
        self.currentPage += 1
        self.searchMovies(key: key) { _, _ in
            
        } failure: { error in
            print("\(error)")
        }
    }
    
    func updateFavoriteMovie(indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let isFavorite = GlobalVariables.shared.favoriteMovies["\(movie.id)"] ?? false
        GlobalVariables.shared.favoriteMovies["\(movie.id)"] = !isFavorite
        movieLocalData.saveOrUpdate(movie: movie, isFavorite: !isFavorite, success: {}) { error in
            self.showErrorMessage?(error.localizedDescription)
        }
        self.reloadCell?(indexPath, !isFavorite)
        self.noticeUpdateFavorite?(!isFavorite)
    }
    
    func getIndexPath(movieId: Int) -> IndexPath? {
        guard let index = movies.firstIndex (where: { $0.id == movieId }) else {
            return nil
        }
        return IndexPath(row: index, section: 0)
    }
    
    func clearData() {
        self.movies = []
        self.reloadTableView?() 
    }
}
