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
}
 
