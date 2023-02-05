//
//  MovieDataService.swift
//  TestMovie
//
//  Created by Tung Phan on 28/01/2023.
//

import Foundation

protocol MovieDataService {
    func getAllMovieCategories(success: @escaping ((_ categories: [MovieCategory]) -> Void), failure: @escaping ((_ error: NetworkServiceError) -> Void))
    func getListMovies(type: MovieHomeType, page: Int, success: @escaping ((_ totalPage: Int, _ movies: [Movie]) -> Void), failure: @escaping ((_ error: NetworkServiceError) -> Void))
    func getMovieDetail(movieId: Int, success: @escaping ((_ movieDetail: MovieDetail) -> Void), failure: @escaping ((_ error: NetworkServiceError) -> Void))
    func searchMovies(key: String, page: Int, success: @escaping ((_ totalPage: Int, _ movies: [Movie]) -> Void), failure: @escaping ((_ error: NetworkServiceError) -> Void))
}
