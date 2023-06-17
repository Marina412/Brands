//
//  OrdersViewModelTest.swift
//  YRStorTests
//
//  Created by marina on 12/06/2023.
//

import XCTest
@testable import YRStor
final class OrdersViewModelTest: XCTestCase {
    var repo : MockRepo?
    var ordersVM: OrdersViewModel?
    
    override func setUpWithError() throws {
        repo  = MockRepo(mockNetworkManager: MockNetworkManager())
        ordersVM = OrdersViewModel(repo: repo!)
    }
    override func tearDownWithError() throws {
        repo = nil
        ordersVM = nil
    }
    
    func testGetAllOrdersFromApi(){
        //when
        ordersVM?.getAllOrdersFromApi(userEmail: "marina")
        //then
        XCTAssertNotEqual(ordersVM?.orders.count, 0)
    }
    
    func testRepoGetAllOrders(){
        //when
        repo?.getAllOrders(completion: { order in
            //then
            XCTAssertNotEqual(order?.count ,0 )
        })
    }
    
}
