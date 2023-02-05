//
//  MovieAPI.swift
//  TestMovie
//
//  Created by Tung Phan on 28/01/2023.
//

import UIKit
import Combine

class MovieAPI: MovieDataService {
    
    var anyCancellables = Set<AnyCancellable>()
    
    func getAllMovieCategories(success: @escaping (([MovieCategory]) -> Void), failure: @escaping ((NetworkServiceError) -> Void)) {
        CombineNetworkService(baseURLString: baseUrl).getPublisherForResponse(endpoint: "genre/movie/list", queryParameters: ["api_key" : apiKey]).sink { completion in
            
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                failure(error)
            }
        } receiveValue: { (genres: MovieCategoryGenres) in
            success(genres.genres)
        }.store(in: &anyCancellables)
    }
    
    func getListMovies(type: MovieHomeType, page: Int, success: @escaping ((Int, [Movie]) -> Void), failure: @escaping ((NetworkServiceError) -> Void)) {
        CombineNetworkService(baseURLString: baseUrl).getPublisherForResponse(endpoint: type.endPoint, queryParameters: ["api_key" : apiKey, "page": "\(page)"]).sink { completion in
            
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                failure(error)
            }
        } receiveValue: { (model: MovieList) in
            print("\(model.totalResults)")
            success(model.totalResults, model.results)
        }.store(in: &anyCancellables)
    }
    
    func getMovieDetail(movieId: Int, success: @escaping ((MovieDetail) -> Void), failure: @escaping ((NetworkServiceError) -> Void)) {
        CombineNetworkService(baseURLString: baseUrl).getPublisherForResponse(endpoint: "movie/\(movieId)", queryParameters: ["api_key" : apiKey]).sink { completion in
            
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                failure(error)
            }
        } receiveValue: { (model: MovieDetail) in
            success(model)
        }.store(in: &anyCancellables)
    }
    
    func searchMovies(key: String, page: Int, success: @escaping ((Int, [Movie]) -> Void), failure: @escaping ((NetworkServiceError) -> Void)) {
        CombineNetworkService(baseURLString: baseUrl).getPublisherForResponse(endpoint: "search/movie", queryParameters: ["api_key" : apiKey, "page": "\(page)", "query": key]).sink { completion in
            
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                failure(error)
            }
        } receiveValue: { (model: MovieList) in
            success(model.totalPages, model.results)
        }.store(in: &anyCancellables)
    }
}
