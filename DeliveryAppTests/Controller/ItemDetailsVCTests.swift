//
//  ItemDetailsVCTests.swift
//  DeliveryAppTests
//
//  Created by Kunal on 20/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import XCTest
@testable import DeliveryApp

class ItemDetailsVCTests: XCTestCase {
    
    var itemDetailsVC: ItemDetailsVC!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        itemDetailsVC = ItemDetailsVC()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        itemDetailsVC = nil
    }
    
    func testControllerHasMap() {
        itemDetailsVC.addElements()
        itemDetailsVC.setupMap()
        XCTAssertNotNil(itemDetailsVC.mapView, "Controller should have a mapView.")
    }
    
    func testGetDetails() {
        let itemModel = ItemModel()
        itemModel.itemId = 0
        itemModel.desc = "Deliver documents to Alan"
        itemModel.imageUrl = "https://google.com"
        itemModel.location = LocationModel(address: "Beijing", lat: 112.50, lng: 56.70)
        
        itemDetailsVC.setDetails(item: itemModel)
        XCTAssertEqual(itemDetailsVC.selectedItem.desc, itemModel.desc)
    }
}
