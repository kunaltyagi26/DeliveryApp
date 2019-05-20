//
//  DeliveryAppTests.swift
//  DeliveryAppTests
//
//  Created by Kunal on 14/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import XCTest
@testable import DeliveryApp

class DeliveryAppTests: XCTestCase {

    var homeVC: HomeVC!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        homeVC = HomeVC()
        homeVC.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testControllerHasTableView() {
        XCTAssertNotNil(homeVC.deliveryTableView, "Controller should have a tableview")
    }
    
    func testTableViewHasCells() {
        let cell = homeVC.deliveryTableView.dequeueReusableCell(withIdentifier: "itemsCell") as? ItemsCell
        XCTAssertNotNil(cell, "TableView should be able to dequeue cell with identifier: 'itemsCell'")
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(homeVC.deliveryTableView.dataSource, "Table datasource cannot be nil")
    }
    
    func testTableViewHasDelegate() {
        XCTAssertNotNil(homeVC.deliveryTableView.delegate, "Table delegate cannot be nil")
    }
    
    func testViewConformsToUITableViewDelegate() {
        XCTAssertTrue(homeVC.conforms(to: UITableViewDelegate.self), "View does not conform to UITableView delegate protocol")
    }
    
    func testViewConformsToUITableViewDataSource() {
        XCTAssertTrue(homeVC.conforms(to: UITableViewDataSource.self), "View does not conform to UITableView datasource protocol")
    }
    
    func testApiResponse() {
        let promise = expectation(description: "Alamofire")
        
        DataService.instance.fetchData(offset: 0) { (success, error, items) in
            XCTAssert(success == true, "The API call failed with error:\(String(describing: error))")
            XCTAssert(error == nil, "The API call failed with error: \(String(describing: error))")
            XCTAssert(items.count == 20, "The Items count is not expected.")
            
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }

}
