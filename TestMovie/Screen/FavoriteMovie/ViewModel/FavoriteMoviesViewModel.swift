//
//  FavoriteMoviesViewModel.swift
//  TestMovie
//
//  Created by Tung Phan on 03/02/2023.
//

import Foundation

class FavoriteMoviesViewModel {
    
    private var favoriteMovies = [MovieLocal]()
    var reloadTableView: (() -> Void)?
    private let movieLocalData: MovieLocalData!
    
    init(movieLocalData: MovieLocalData) {
        self.movieLocalData = movieLocalData
    }
    
    func fetchData() {
        favoriteMovies = movieLocalData.fetchAllData().filter { $0.isFavorite }
        reloadTableView?()
    }
    
    func getItemCells() -> [SearchCellType] {
        if favoriteMovies.isEmpty {
            return [.blank]
        }
        var data = [SearchCellType]()
        favoriteMovies.forEach { _ in data.append(.movie) }
        return data
    }
    
    func getItemViewModel(indexPath: IndexPath) -> ItemFavoriteMoviesViewModel {
        return ItemFavoriteMoviesViewModel(model: favoriteMovies[indexPath.row])
    }
    
    func getIdMovie(indexPath: IndexPath) -> Int {
        return Int(favoriteMovies[indexPath.row].id)!
    }
    
    func search(text: String) {
//        self.favoriteMovies = MovieLocalData.shared.fetchAllData().filter { $0.isFavorite && ( $0.title?.contain(otherString: text) ) }
    }
}
