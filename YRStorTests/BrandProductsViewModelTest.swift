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
        brandProductVM?.allProducts =  [Product(id: 1, title: "adidas" ,productType:"Acessory" ,variants: [Variant(price: "10")]),Product(id: 1, title: "adidas" ,productType:"Acessory" ,variants: [Variant(price: "10")]),Product(id: 1, title: "adidas" ,productType:"T_Shirt" ,variants: [Variant(price: "10")]),Product(id: 1, title: "adidas" ,productType:"Shoes" ,variants: [Variant(price: "10")])]
    }
    override func tearDownWithError() throws {
        repo = nil
        brandProductVM = nil
    }
    
    func testsetUpData(){
        //when
        brandProductVM?.setUpData(brandId: 0){
            //then
            XCTAssertNotEqual(self.brandProductVM?.allProductsIDs.count , 0)
        }
        
    }
    func testGetAllProductsFromApiByCategorry(){
        //when
        brandProductVM?.getAllProductsFromApiByCategorry(collectionId: 1){
            //then
            XCTAssertNotEqual(self.brandProductVM?.allProductsIDs.count , 0)
        }
    }
    func testRepoGgetProductsByCollectionId(){
        repo?.getProductsByCollectionId(collectionId: 0){
            productsResult in
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
    func testFilterProudactsNotSearch(){
        //when
        brandProductVM?.filterProudacts(searchText: "")
        //then
        XCTAssertEqual(brandProductVM?.filterProducts.count , 0)
        }
    func testFilterProudacts(){
        //when
         brandProductVM?.filterProudacts(searchText: "T_Shirt")
        //then
        XCTAssertNotEqual(brandProductVM?.filterProducts.count , 0)
        }
}

