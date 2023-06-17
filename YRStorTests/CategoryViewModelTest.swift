//
//  CategoryViewModelTest.swift
//  YRStorTests
//
//  Created by marina on 12/06/2023.
//

import XCTest
@testable import YRStor
final class CategoryViewModelTest: XCTestCase {
    
    var repo : MockRepo?
    var categoryVM: CategoryViewModel?
    override func setUpWithError() throws {
        repo  = MockRepo(mockNetworkManager: MockNetworkManager())
        categoryVM = CategoryViewModel(repo: repo!)
    }
    override func tearDownWithError() throws {
       repo = nil
        categoryVM = nil
    }
    func testGetAllProductsFromApiByCategorry(){
        //when
        categoryVM?.getAllProductsFromApiByCategorry{
            //then
            XCTAssertNotEqual(self.categoryVM?.allProductsIDs.count , 0)
        }
    }
    func testRepoGetAllProducts(){
        repo?.getAllProducts(){
            productsResult in
            //then
            XCTAssertNotEqual(productsResult?.count , 0)
        }
    }
    
    func testGetAllPoductsPricesFromApi(){
        //when
        categoryVM?.getAllPoductsPricesFromApi{
            //then
            XCTAssertNotEqual(self.categoryVM?.allProducts.count , 0)
        }
    }
    func testRepoGetAllProductsPric(){
        //when
        repo?.getAllProductsPrice(productIds:[1,2,3,4,5,6]){
            productsResult in
            //then
            XCTAssertNotEqual(productsResult?.count , 0)
        }
    }
    
    func testCurrencySetUpCurrencyType(){
        //when
        categoryVM?.currencySetUp()
        //then
        XCTAssertNotEqual(categoryVM?.curencyType , "")
    }
    func testCurrencySetUpExchange(){
        //when
        categoryVM?.currencySetUp()
        //then
        XCTAssertNotEqual(categoryVM?.rates.USD , 0.0)
    }
    func testRepoGetCurrency(){
        //when
        repo?.getCurrency{
            res in
            //then
            XCTAssertNotEqual(res?.USD , 0.0)
        }
    }

}
