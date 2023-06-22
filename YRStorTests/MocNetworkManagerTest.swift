//
//  MocNetworkManagerTest.swift
//  YRStorTests
//
//  Created by Huda kamal  on 22/06/2023.
//

import XCTest
@testable import YRStor
final class MocNetworkManagerTest: XCTestCase {
    var mockNetworkManager = MockNetworkManager()
    
    var isCustomerSaved = false

    func testAllProductDecoding() {
        mockNetworkManager.mockAllProductsResponse = "{\"products\":[{\"id\":1,\"title\":\"Product Title 1\",\"body_html\":\"Product Body HTML 1\",\"vendor\":\"Product Vendor 1\"},{\"id\":2,\"title\":\"Product Title 2\",\"body_html\":\"Product Body HTML 2\",\"vendor\":\"Product Vendor 2\"}]}"
        var url = Constant.ALL_PRODUCTS_URL
        mockNetworkManager.getDataFromApi(apiUrl: "", val: AllProudects.self) { res in
            guard let result = res else {
                XCTFail()
                return
            }
          //  XCTAssertNotEqual(result.products.count , 0, "Fail")
            XCTAssertEqual(result.products?.count, 2, "pass")
        }
    }
    
    
    func testFavProductsDecoding(){
        mockNetworkManager.mockAllProductsResponse = """
{
    "draft_orders": [
        {
            "id": 1,
            "email": "test@example.com",
            "line_items": [
                {
                    "sku": "123",
                    "title": "Product 1",
                    "price": "10.00",
                    "quantity": 1
                },
                {
                    "sku": "456",
                    "title": "Product 2",
                    "price": "20.00",
                    "quantity": 2
                }
            ],
            "note": "favorite"
        }
    ]
}
"""
        
        var url = Constant.GET_ALL_FAV_URL
        mockNetworkManager.getDataFromApi(apiUrl: "", val: FavProducts.self) { res in
            guard let result = res else {
                XCTFail()
                return
            }
          //  XCTAssertNotEqual(result.products.count , 0, "Fail")
            XCTAssertEqual(result.draftOrders.count, 1, "pass")
        }
        
    }
    
    func testCustomersDecoding(){
        mockNetworkManager.mockAllProductsResponse = """
{
    "customers": [
        {
            "id": 1,
            "first_name" : "huda",
            "last_name" : "kamal",
            "email": "test@example.com",
            "note": "12345",
            "phone": "123456"
        },
        {
            "id": 1,
            "first_name" : "huda",
            "last_name" : "kamal",
            "email": "test@example.com",
            "note": "12345",
            "phone": "123456"
        }
    ]
}
"""
        var url = Constant.GET_ALL_FAV_URL
        mockNetworkManager.getDataFromApi(apiUrl: "", val: AllCustomers.self) { res in
            guard let result = res else {
                XCTFail()
                return
            }
          //  XCTAssertNotEqual(result.products.count , 0, "Fail")
            XCTAssertEqual(result.customers[0].firstName, "huda", "pass")
        }
        
    }
    
}
