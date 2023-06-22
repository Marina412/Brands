//
//  AuthViewModelTest.swift
//  YRStorTests
//
//  Created by Huda kamal  on 22/06/2023.
//

import XCTest
@testable import YRStor
final class AuthViewModelTest: XCTestCase {


    var mockRepo = MockRepo(mockNetworkManager: MockNetworkManager())
    
    
    func testGetAllCustomers() {
        var auth = AuthViewModel(repo: mockRepo)
        let expectation = XCTestExpectation(description: "Get all customers")
        auth.bindResult = {
            expectation.fulfill()
        }
        auth.getAllCustomers()
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(auth.viewModelResult.customers.count, 2)
    }
    
}
