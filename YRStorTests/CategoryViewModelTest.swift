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
        categoryVM?.allProducts =  [Product(id: 1, title: "adidas" ,productType:"Acessory" ,tags: "woman",variants: [Variant(price: "10")]),Product(id: 1, title: "adidas" ,productType:"Acessory",tags: "man" ,variants: [Variant(price: "10")]),Product(id: 1, title: "adidas" ,productType:"T_Shirt",tags: "kid" ,variants: [Variant(price: "10")]),Product(id: 1, title: "adidas" ,productType:"Shoes" ,tags: "sale",variants: [Variant(price: "10")])]
    }
    override func tearDownWithError() throws {
       repo = nil
        categoryVM = nil
    }
    
    func testSetUpData(){
        //when
        categoryVM?.setUpData(){
            //then
            XCTAssertNotEqual(self.categoryVM?.allProductsIDs.count , 0)
        }
        
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
    
    func testFilterProudactsNotSearch(){
        //when
        categoryVM?.filterProudacts(searchText: "")
        //then
        XCTAssertEqual(categoryVM?.filterProducts.count , 0)
        }
    func testFilterProudacts(){
        //when
        categoryVM?.filterProudacts(searchText: "T_Shirt")
        //then
        XCTAssertNotEqual(categoryVM?.filterProducts.count , 0)
        }
    
    func testFilterProudactsByMainCategoryNotSearch(){
        //when
        categoryVM?.filterProudactsByMainCategory(categoryName: "")
        //then
        XCTAssertEqual(categoryVM?.filterProducts.count , 0)
        }
    func testFilterProudactsByMainCategory(){
        //when
        categoryVM?.filterProudactsByMainCategory(categoryName: "woman")
        //then
        XCTAssertNotEqual(categoryVM?.filterProducts.count , 0)
        }
    
     func testFilterProudactsBySubCategoryNotSearch(){
        //when
        categoryVM?.filterProudactsBySubCategory(categoryName: "")
        //then
        XCTAssertEqual(categoryVM?.filterProducts.count , 0)
        }
    func testFilterProudactsBySubCategory(){
        //when
        categoryVM?.filterProudactsBySubCategory(categoryName: "T_Shirt")
        //then
        XCTAssertNotEqual(categoryVM?.filterProducts.count , 0)
        }
    
    
   
    
    
    
}
