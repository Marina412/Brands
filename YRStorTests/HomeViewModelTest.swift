//
//  HomeViewModelTest.swift
//  YRStorTests
//
//  Created by marina on 14/06/2023.
//

import XCTest
@testable import YRStor

final class HomeViewModelTest: XCTestCase {
    
    var repo : MockRepo?
    var homeVM:  HomeViewModel?
    
    override func setUpWithError() throws {
        repo  = MockRepo(mockNetworkManager: MockNetworkManager())
        homeVM = HomeViewModel(repo: repo!)
    }
    override func tearDownWithError() throws {
       repo = nil
        homeVM = nil
    }
    func testGetAllBransFromApi() {
        //when
        homeVM?.getAllBransFromApi()
        //then
        XCTAssertNotEqual(homeVM?.brands.count , 0)
    }
    func testRepoGetAllBransFromApi() {
        //when
        repo?.getAllProducts(completion: { products in
            //then
            XCTAssertNotEqual(products?.count ,0 )
        })
        
    }

}
