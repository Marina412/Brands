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
        homeVM?.getAllCategoriesFromApi{
            
            //then
            XCTAssertNotEqual(self.homeVM?.brands.count , 0)
        }
    }
    func testRepoGetAllBransFromApi() {
        //when
        repo?.getAllProducts(completion: { products in
            //then
            XCTAssertNotEqual(products?.count ,0 )
        })
        
    }
    func testremoveItemFromCupon(){
        homeVM?.cupons = ["15%","25%","35%"]
        homeVM?.removeItemFromCupon(index:1)
        XCTAssertEqual( homeVM?.cupons.count ,2 )
        
    }
    func testloadCupon(){
        homeVM?.loadCupon()
        XCTAssertNotEqual( homeVM?.cupons.count ,0 )
    }

}
