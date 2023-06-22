//
//  SearchavaiewmodelTest.swift
//  YRStorTests
//
//  Created by Huda kamal  on 22/06/2023.
//

import XCTest
@testable import YRStor
final class SearchavaiewmodelTest: XCTestCase {

    var mockRepo = MockRepo(mockNetworkManager: MockNetworkManager())
    
    func testGetAllProducts() {
        var viewModel = SearchViewModel(repo: mockRepo)
        let expectation = XCTestExpectation(description: "Get all products")
        viewModel.bindResult = {
            expectation.fulfill()
        }
        viewModel.getAllProducts()
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(viewModel.viewModelResult?.count, 17)
    }

}
