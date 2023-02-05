//
//  MovieMockDataSuccess.swift
//  TestMovieTests
//
//  Created by Tung Phan on 05/02/2023.
//

import Foundation
@testable import TestMovie

class MovieMockDataSuccess: MovieDataService {
    func getAllMovieCategories(success: @escaping (([MovieCategory]) -> Void), failure: @escaping ((NetworkServiceError) -> Void)) {
        let category1 = MovieCategory(id: 26, name: "Action")
        let category2 = MovieCategory(id: 27, name: "Adventure")
        let category3 = MovieCategory(id: 28, name: "Animation")
        let category4 = MovieCategory(id: 29, name: "Comedy")
        success([category1, category2, category3, category4])
    }
    
    func getListMovies(type: MovieHomeType, page: Int, success: @escaping ((Int, [Movie]) -> Void), failure: @escaping ((NetworkServiceError) -> Void)) {
        let movie1 = Movie(adult: true, backdropPath: "", genreIDS: [1, 2], id: 1, originalTitle: "original title 1", overview: "overview 1", popularity: 1, posterPath: "", releaseDate: "01/01/2023", title: "title 1", video: false, voteAverage: 3.5, voteCount: 5)
        let movie2 = Movie(adult: true, backdropPath: "", genreIDS: [1, 2], id: 1, originalTitle: "original title 2", overview: "overview 2", popularity: 1, posterPath: "", releaseDate: "01/01/2023", title: "title 2", video: false, voteAverage: 3.5, voteCount: 5)
        success(12, [movie1, movie2])
    }
    
    func getMovieDetail(movieId: Int, success: @escaping ((MovieDetail) -> Void), failure: @escaping ((NetworkServiceError) -> Void)) {
        let movieDetail = MovieDetail(adult: true, backdropPath: "", belongsToCollection: nil, budget: 1234, genres: [Genre(id: 1, name: "Action"), Genre(id: 2, name: "animation")], homepage: "home", id: 1, imdbID: "1", originalLanguage: "en", originalTitle: "title", overview: "overview", popularity: 1.2, posterPath: "", productionCompanies: [], productionCountries: [], releaseDate: "01/01/2023", revenue: 123, runtime: 1, spokenLanguages: [], status: "", tagline: "action", title: "title", video: false, voteAverage: 1.2, voteCount: 3)
        success(movieDetail)
    }
    
    func searchMovies(key: String, page: Int, success: @escaping ((Int, [Movie]) -> Void), failure: @escaping ((NetworkServiceError) -> Void)) {
        let movie1 = Movie(adult: true, backdropPath: "", genreIDS: [1, 2], id: 1, originalTitle: "original title 1", overview: "overview 1", popularity: 1, posterPath: "", releaseDate: "01/01/2023", title: "title 1", video: false, voteAverage: 3.5, voteCount: 5)
        let movie2 = Movie(adult: true, backdropPath: "", genreIDS: [1, 2], id: 1, originalTitle: "original title 2", overview: "overview 2", popularity: 1, posterPath: "", releaseDate: "01/01/2023", title: "title 2", video: false, voteAverage: 3.5, voteCount: 5)
        success(12, [movie1, movie2])
    }
    
    
}
