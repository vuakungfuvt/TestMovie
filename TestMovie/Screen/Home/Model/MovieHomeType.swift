//
//  MovieHomeType.swift
//  TestMovie
//
//  Created by Tung Phan on 29/01/2023.
//

import Foundation

enum MovieHomeType {
    case nowPlaying
    case popular
    case topRated
    case upComing
    
    var name: String {
        switch self {
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        case .upComing:
            return "Upcoming"
        }
    }
    
    var endPoint: String {
        switch self {
        case .nowPlaying:
            return "movie/now_playing"
        case .popular:
            return "movie/popular"
        case .topRated:
            return "movie/top_rated"
        case .upComing:
            return "movie/upcoming"
        }
    }
}
