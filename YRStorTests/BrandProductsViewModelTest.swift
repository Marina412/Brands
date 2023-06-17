//
//  BrandProductsViewModelTest.swift
//  YRStorTests
//
//  Created by marina on 17/06/2023.
//

import XCTest
@testable import YRStor
final class BrandProductsViewModelTest: XCTestCase {
    var repo : MockRepo?
    var brandProductVM: BrandProductsViewModel?
    override func setUpWithError() throws {
        repo  = MockRepo(mockNetworkManager: MockNetworkManager())
        brandProductVM = BrandProductsViewModel(repo: repo!)
    }
    override func tearDownWithError() throws {
        repo = nil
        brandProductVM = nil
    }
    func testGetAllProductsFromApiByCategorry(){
        //when
        brandProductVM?.getAllProductsFromApiByCategorry(collectionId: 1){
            //then
            XCTAssertNotEqual(self.brandProductVM?.allProductsIDs.count , 0)
        }
    }
    func testRepoGgetProductsByCollectionId(){
        repo?.getProductsByCollectionId(collectionId: 0){          productsResult in
            //then
            XCTAssertNotEqual(productsResult?.count , 0)
        }
    }
    
    func testGetAllPoductsPricesFromApi(){
        //when
        brandProductVM?.getAllPoductsPricesFromApi{
            //then
            XCTAssertNotEqual(self.brandProductVM?.allProducts.count , 0)
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
        brandProductVM?.currencySetUp()
        //then
        XCTAssertNotEqual(brandProductVM?.curencyType , "")
    }
    func testCurrencySetUpExchange(){
        //when
        brandProductVM?.currencySetUp()
        //then
        XCTAssertNotEqual(brandProductVM?.rates.USD , 0.0)
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

