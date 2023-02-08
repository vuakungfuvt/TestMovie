//
//  HomeViewModelTest.swift
//  TestMovieTests
//
//  Created by Tung Phan on 05/02/2023.
//

import XCTest
@testable import TestMovie

final class HomeViewModelTest: XCTestCase {
    
    private var viewModel: HomeViewModel!
    private var localData: MovieLocalData!

    override func setUp() {
        let context = MovieLocalData.shared.setUpInMemoryManagedObjectContext()
        localData = MovieLocalData(context: context)
        
        self.viewModel = HomeViewModel(service: MovieMockDataFailure(), movieLocalData: localData)
    }

    func testGetAllCategories() {
        
        viewModel.setAdapter(service: MovieMockDataSuccess())
        let expectationSuccess = expectation(description: "Test Get Categories API Success")
        viewModel.getAllCategoriesFilm { categories in
            XCTAssertEqual(categories.count, 4)
            let category = categories[0]
            XCTAssertEqual(category.id, 26)
            XCTAssertEqual(category.name, "Action")
            expectationSuccess.fulfill()
        } failure: { _ in
            
        }
        wait(for: [expectationSuccess], timeout: 1)
        
        viewModel.setAdapter(service: MovieMockDataFailure())
        let expectationFailure = expectation(description: "Test Get Categories API Success")
        viewModel.getAllCategoriesFilm(success: { categories in
        }) { error in
            XCTAssertNotNil(error)
            expectationFailure.fulfill()
        }
        wait(for: [expectationFailure], timeout: 1)
    }
    
    func testUpdateFavoriteMovie() {
        let movie1 = Movie(adult: true, backdropPath: "", genreIDS: [1, 2], id: 1, originalTitle: "original title 1", overview: "overview 1", popularity: 1, posterPath: "", releaseDate: "01/01/2023", title: "title 1", video: false, voteAverage: 3.5, voteCount: 5)
        viewModel.updateFavoriteMovie(movie: movie1, isFavorite: true)
        let movieLocal = localData.getMovieLocal(id: "1")
        XCTAssertTrue(movieLocal?.isFavorite ?? false)
    }
}
 
