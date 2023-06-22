//
//  CustomerAddressViewModelTest.swift
//  YRStorTests
//
//  Created by Huda kamal  on 22/06/2023.
//

import XCTest
@testable import YRStor
final class CustomerAddressViewModelTest: XCTestCase {

    var mockRepo = MockRepo(mockNetworkManager: MockNetworkManager())
    
    
    func testGetAllCustomersAddresses() {
        var viewModel = CustomerAddressViewModel(repo: mockRepo)
        let expectation = XCTestExpectation(description: "Get all customers addreses ")
        viewModel.bindResult = {
            expectation.fulfill()
        }
        viewModel.getAllAdresses(customerId: "")
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(viewModel.viewModelResult?.addresses?.count, 3)
    }

}
