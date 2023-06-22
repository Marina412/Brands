//
//  FavViewModelTest.swift
//  YRStorTests
//
//  Created by Huda kamal  on 22/06/2023.
//

import XCTest
@testable import YRStor
final class FavViewModelTest: XCTestCase {
    
     var mockRepo = MockRepo(mockNetworkManager: MockNetworkManager())
     
     func testGetAllFav() {
         var viewModel = FavViewModel(repo: mockRepo)
         var authViewModel = AuthViewModel(repo: Repo(networkManager: NetworkManager()))
         let expectation = XCTestExpectation(description: "Get all products")
         viewModel.bindResult = {
             expectation.fulfill()
         }
         viewModel.getAllFav()
         wait(for: [expectation], timeout: 5.0)
         XCTAssertEqual(viewModel.viewModelResult?.draftOrders.count , 2)
     }
    

}
