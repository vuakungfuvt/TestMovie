//
//  MovieMockDataFailure.swift
//  TestMovieTests
//
//  Created by Tung Phan on 05/02/2023.
//

import Foundation
@testable import TestMovie

class MovieMockDataFailure: MovieDataService {
    
    func getAllMovieCategories(success: @escaping (([MovieCategory]) -> Void), failure: @escaping ((NetworkServiceError) -> Void)) {
        failure(.genericError("Not found"))
    }
    
    func getListMovies(type: MovieHomeType, page: Int, success: @escaping ((Int, [Movie]) -> Void), failure: @escaping ((NetworkServiceError) -> Void)) {
        failure(.genericError("Not found"))
    }
    
    func getMovieDetail(movieId: Int, success: @escaping ((MovieDetail) -> Void), failure: @escaping ((NetworkServiceError) -> Void)) {
        failure(.genericError("Not found"))
    }
    
    func searchMovies(key: String, page: Int, success: @escaping ((Int, [Movie]) -> Void), failure: @escaping ((NetworkServiceError) -> Void)) {
        failure(.genericError("Not found"))
    }
    
    init() {
        
    }
    
}
