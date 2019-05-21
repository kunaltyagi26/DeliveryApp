//
//  APIManagerTests.swift
//  AssignmentTests
//
//  Created by Kanika on 16/05/19.
//  Copyright © 2019 Kanika. All rights reserved.
//

import XCTest
@testable import DeliveryApp

class APIManagerTests: XCTestCase {
    
    let host = "mock-api-mobile.dev.lalamove.com"
    
    func testSuccessDeliveryData() {
        XCStub.request(withPathRegex: host, withResponseFile: "MockItemsData.json")
        let promise = expectation(description: "expected data from the json file")
        
        APIDataService.instance.fetchData(offset: 0) { (_, _, items) in
            XCTAssertNotNil(items)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 20) { error in
            if let error = error {
                XCTAssertNotNil(error, "Webservice response returns with error")
            }
        }
    }
    
    func testFailureDeliveryData() {
        XCStub.request(withPathRegex: host, withResponseFile: "MockItemsData_Invalid.json")
        let promise = expectation(description: "expected error from the invalid json file")
        
        APIDataService.instance.fetchData(offset: 0) { (_, errorMsg, _) in
            XCTAssertNotNil(errorMsg)
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 20) { error in
            if let error = error {
                XCTAssertNotNil(error, "Webservice response returns with error")
            }
        }
    }
    
}
