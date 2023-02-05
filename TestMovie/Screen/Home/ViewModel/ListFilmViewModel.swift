//
//  ListFilmViewModel.swift
//  TestMovie
//
//  Created by Tung Phan on 29/01/2023.
//

import Foundation

enum ItemHomeMovieCellType {
    case movie
    case loadMore
}

class ListFilmViewModel {
    
    private var homeType: MovieHomeType
    private var movies = [Movie]()
    private let service: MovieDataService
    private var totalPage: Int = 0
    private var currentPage: Int = 1
    var itemCellViewModel: [ItemHomeMovieCellViewModel] = [ItemHomeMovieCellViewModel]()
    var reloadCollectionView: (() -> Void)?
    var noticeUpdateFavorite: ((_ isFavorite: Bool) -> Void)?
    var reloadCell: ((_ indexPath: IndexPath, _ isFavorite: Bool) -> Void)?
    var showErrorMessage: ((_ message: String) -> Void)?
    
    init(homeType: MovieHomeType, service: MovieDataService) {
        self.homeType = homeType
        self.service = service
    }
    
    func getListMovies(success: @escaping ((Int, [Movie]) -> Void), failure: @escaping ((NetworkServiceError) -> Void)) {
        service.getListMovies(type: homeType, page: currentPage) { totalPage, movies in
            if self.currentPage == 1 {
                self.movies = movies
            } else {
                self.movies += movies
            }
            self.totalPage = totalPage
            self.itemCellViewModel = self.movies.compactMap { ItemHomeMovieCellViewModel(movie: $0) }
            success(totalPage, movies)
            self.reloadCollectionView?()
        } failure: { error in
            failure(error)
            self.showErrorMessage?(error.localizedDescription)
        }
    }
    
    func getItemCells() -> [ItemHomeMovieCellType] {
        var data = [ItemHomeMovieCellType]()
        movies.forEach { _ in data.append(.movie) }
        if currentPage < totalPage {
            data.append(.loadMore)
        }
        return data
    }
    
    func getModel(indexPath: IndexPath) -> Movie {
        return movies[indexPath.item]
    }
    
    func refresh() {
        self.currentPage = 1
        self.getListMovies() { _, _ in
            
        } failure: { _ in
            
        }

    }
    
    func loadMore() {
        self.currentPage += 1
        self.getListMovies() { _, _ in
            
        } failure: { error in
            print("\(error)")
        }
    }
    
    func getIndexPath(movieId: Int) -> IndexPath? {
        guard let index = self.movies.firstIndex(where: { movie in
            return movie.id == movieId
        }) else {
            return nil
        }
        return IndexPath(item: index, section: 0)
    }
    
    func getMovieInfor(indexPath: IndexPath) -> (Movie, Bool) {
        let movie = self.movies[indexPath.item]
        let isFavorite = self.movies[indexPath.item].getIsFavorite()
        return (movie, isFavorite)
    }
}
