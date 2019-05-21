//
//  CoreDataTests.swift
//  DeliveryAppTests
//
//  Created by Kunal on 20/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import XCTest
import CoreData
@testable import DeliveryApp

class CoreDataTests: XCTestCase {

    var containerName = "DeliveryApp"
    var coreDataContainerObj: CoreDataService!
    var homeVC: HomeVC!
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName, managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition( description.type == NSInMemoryStoreType )
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        if let managedObjectModel = NSManagedObjectModel.mergedModel(from: nil) {
            return managedObjectModel
        }
        return NSManagedObjectModel()
    }()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataContainerObj = CoreDataService(container: mockPersistantContainer)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        coreDataContainerObj = nil
    }

    func testData() -> ItemModel {
        let itemModel = ItemModel()
        itemModel.itemId = 0
        itemModel.desc = "Deliver documents to Alan"
        itemModel.imageUrl = "https://google.com"
        itemModel.location = LocationModel(address: "Beijing", lat: 112.50, lng: 56.70)
        return itemModel
    }
    
    func testAddItem() {
        let item = testData()
        coreDataContainerObj.saveLocalData(item: [item]) { (errorMsg) in
            XCTAssertNil(errorMsg, "There is some error.")
        }
    }
    
    func testfetchItems() {
        let item1 = testData()
        let item2 = testData()
        let item3 = testData()
        let fItems = [item1, item2, item3]
        coreDataContainerObj.saveLocalData(item: fItems) { (_) in
        }
        
        coreDataContainerObj.fetchLocalData(offset: 0, completion: { (_, items) in
            XCTAssertEqual(fItems.count, items.count)
        })
    }
    
    func testModelIsConverted() {
        let item = testData()
        coreDataContainerObj.saveLocalData(item: [item]) { (_) in
        }
        
        coreDataContainerObj.fetchLocalData(offset: 0, completion: { (_, items) in
            let fetchedItem = items[0]
            homeVC = HomeVC()
            homeVC.convertToModel(coreModel: fetchedItem) { itemModel in
                XCTAssertEqual(item.desc, itemModel.desc, "The converted value of the model should be equal to the original core data model.")
            }
        })
    }
}
