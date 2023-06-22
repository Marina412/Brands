//
//  CustomerAddressViewModelTest.swift
//  YRStorTests
//
//  Created by Huda kamal  on 22/06/2023.
//

import XCTest
@testable import YRStor
final class CustomerAddressViewModelTest: XCTestCase {

    var viewModel = CustomerAddressViewModel(repo: MockRepo(mockNetworkManager: NetworkManager()))
   
    
    func testGetAllCustomersAddresses() {
        
        let expectation = XCTestExpectation(description: "Get all customers addreses ")
        viewModel.bindResult = {
            expectation.fulfill()
        }
        viewModel.getAllAdresses(customerId: "")
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(viewModel.viewModelResult?.addresses?.count, 3)
    }
    
    func testGetOneAddressForCustomer(){
        let expectation = XCTestExpectation(description: "Get one customer addreses ")
        viewModel.bindResult = {
            expectation.fulfill()
        }
        viewModel.getAllAdresses(customerId: "")
        wait(for: [expectation], timeout: 5.0)
        XCTAssertTrue(((viewModel.viewModelResult?.addresses?[0].customer_id) != nil), "1")
    }

}
