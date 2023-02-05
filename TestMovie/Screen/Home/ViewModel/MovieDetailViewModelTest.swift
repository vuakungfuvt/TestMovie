//
//  MovieDetailViewModelTest.swift
//  TestMovie
//
//  Created by Tung Phan on 28/01/2023.
//

import XCTest
@testable import TestMovie

final class MovieDetailViewModelTest: XCTestCase {
    
    private var viewModel: MovieDetailViewModel!

    override func setUp() {
        self.viewModel = MovieDetailViewModel(movieId: 1, service: MovieMockDataSuccess())
    }
}
