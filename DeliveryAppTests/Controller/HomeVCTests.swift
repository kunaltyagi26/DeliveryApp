//
//  HomeVCTests.swift
//  DeliveryAppTests
//
//  Created by Kunal on 20/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import XCTest
import ObjectMapper
@testable import DeliveryApp

class HomeVCTests: XCTestCase {
    
    var homeVC: HomeVC!
    var coreDataServiceTest: CoreDataServiceTest!
    var apiDataServiceTest: APIDataServiceTest!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        homeVC = HomeVC()
        coreDataServiceTest = CoreDataServiceTest()
        homeVC.coreDataService = coreDataServiceTest
        apiDataServiceTest = APIDataServiceTest()
        homeVC.apiDataService = apiDataServiceTest
        homeVC.loadViewIfNeeded()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        homeVC = nil
    }
    
    func testControllerHasTableView() {
        homeVC.addElements()
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
    
    func testInternetConnection() {
        XCTAssertEqual(Connectivity.isConnectedToInternet, true, "Application should have a continuous internet connection.")
    }
    
    /*func testCheckCountAfterFetchingFromAPI() {
        homeVC.getApiData(offset: 0) { (_, _, items) in
            self.homeVC.deliveryItems = items ?? [ItemModel]()
            
            XCTAssertEqual(self.homeVC.deliveryTableView.numberOfRows(inSection: 0), items?.count)
        }
    }*/
    
    func testData() -> ItemModel {
        let itemModel = ItemModel()
        itemModel.itemId = 0
        itemModel.desc = "Deliver documents to Alan"
        itemModel.imageUrl = "https://google.com"
        itemModel.location = LocationModel(address: "Beijing", lat: 112.50, lng: 56.70)
        return itemModel
    }
    
    func testSavingLocalDataSucceeded() {
        let item = testData()
        coreDataServiceTest.saveLocalData(item: [item]) { (errorMsg) in
            XCTAssertNil(errorMsg, "There is some error while saving.")
        }
    }
    
    func testSavingLocalDataFailed() {
        let item = testData()
        coreDataServiceTest.isError = true
        coreDataServiceTest.saveLocalData(item: [item]) { (errorMsg) in
            XCTAssertNotNil(errorMsg, "There is no error while saving.")
        }
    }
    
    /*func testFetchLocalData() {
        coreDataServiceTest.fetchLocalData(offset: 0) { (errorMsg, _) in
            XCTAssertNil(errorMsg, "There is some error while fetching.")
        }
    }*/
    
    func testFetchDataFromAPISucceeded() {
        apiDataServiceTest.fetchData(offset: 0) { (_, _, items) in
            XCTAssertNotNil(items, "Items is nil.")
        }
    }
    
    func testFetchDataFromAPIFailed() {
        apiDataServiceTest.isError = true
        apiDataServiceTest.fetchData(offset: 0) { (_, _, items) in
            XCTAssertNil(items, "Items is not nil.")
        }
    }
}

class CoreDataServiceTest: CoreDataServiceDelegate {
   
    var isError = false
    
    func saveLocalData(item: [ItemModel], completionHandler: ((String?) -> Void)) {
        if isError == false {
            completionHandler(nil)
        } else {
            completionHandler("error")
        }
        
   }
    
    func fetchLocalData(offset: Int, completion: (String?, [Item]) -> Void) {
        /*let item1 = testData()
        let item2 = testData()
        let items = [item1, item2]
        let ij = Item()
        saveLocalData(item: items) { (errorMsg) in
            if errorMsg == nil {
                if isError == false {
//                    completion(nil, [Item(), Item()])
                } else {
                    completion("error", [Item]())
                }
            }
        }*/
    }
    
    func deleteAllData(entity: String, completionHandler: ((_ error: String?) -> Void)) {
        
    }
    
    func testData() -> ItemModel {
        let itemModel = ItemModel()
        itemModel.itemId = 0
        itemModel.desc = "Deliver documents to Alan"
        itemModel.imageUrl = "https://google.com"
        itemModel.location = LocationModel(address: "Beijing", lat: 112.50, lng: 56.70)
        return itemModel
    }
}

class APIDataServiceTest: APIDataServiceDelegate {
    var isError = false
    
    func fetchData(offset: Int, completionHandler: @escaping ((Bool, String?, [ItemModel]?) -> Void)) {
        let bundle = Bundle(for: type(of: self))
        var path: String = ""
        if isError == false {
            path = bundle.path(forResource: "MockItemsData", ofType: "json") ?? ""
        } else {
            path = bundle.path(forResource: "MockItemsData_invalid", ofType: "json") ?? ""
        }
        //let path = bundle.path(forResource: "MockItemsData", ofType: "json")
        let data = NSData(contentsOfFile: path )
        do {
            let data = (try JSONSerialization.jsonObject(with: (data ?? NSData()) as Data, options: []) as? [[String: Any]])!
            let items = Mapper<ItemModel>().mapArray(JSONArray: data)
            completionHandler(true, nil, items)
        } catch {
            completionHandler(false, nil, nil)
        }
    }
}
