//
//  MovieData.swift
//  TestMovie
//
//  Created by Tung Phan on 03/02/2023.
//

import Foundation

protocol MovieData {
    func getId() -> String
    func getBackdropPath() -> String
    func getOverview() -> String
    func getPosterPath() -> String
    func getReleaseDate() -> String
    func getTitle() -> String
    func getVoteCount() -> String
    func getVoteAverage() -> String
    func getGenresId() -> String
    func getIsFavorite() -> Bool
}
