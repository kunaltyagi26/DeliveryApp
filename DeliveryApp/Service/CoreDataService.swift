//
//  CoreDataService.swift
//  DeliveryApp
//
//  Created by Kunal on 16/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import UIKit
import CoreData

protocol CoreDataServiceDelegate: class {
    func saveLocalData(item: [ItemModel], completionHandler: ((_ error: String?) -> Void))
    func fetchLocalData(offset: Int, completion: (_ error: String?, _ localData: [Item]) -> Void)
    func deleteAllData(entity: String, completionHandler: ((_ error: String?) -> Void))
}

class CoreDataService: CoreDataServiceDelegate {

    // MARK: Variables
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var context: NSManagedObjectContext!
    
    // MARK: Initialization
    init() {
        context = appDelegate?.persistentContainer.viewContext
    }
    
    init(container: NSPersistentContainer) {
        appDelegate?.persistentContainer = container
        appDelegate?.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        context = container.viewContext
    }
    
    // MARK: Save local data
    func saveLocalData(item: [ItemModel], completionHandler: ((_ error: String?) -> Void)) {
        for itemModel in item {
            let item = Item(context: self.context!)
            guard let itemId = itemModel.itemId else { return }
            item.id = Int32(itemId)
            item.desc = itemModel.desc
            item.imageUrl = itemModel.imageUrl
            item.latitude = itemModel.location?.lat ?? 0.0
            item.longitude = itemModel.location?.lng ?? 0.0
            item.address = itemModel.location?.address
            
            do {
                try self.context?.save()
                completionHandler(nil)
            } catch {
                completionHandler(error.localizedDescription)
            }
        }
    }
    
    // MARK: Fetch local data
    func fetchLocalData(offset: Int, completion: (_ error: String?, _ localData: [Item]) -> Void) {
        let fetchRequest = NSFetchRequest<Item>(entityName: entityName)
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = limit
        var data = [Item]()
        do {
            data = try context?.fetch(fetchRequest) ?? []
            completion(nil, data)
        } catch {
            completion(error.localizedDescription, data)
        }
    }
    
    // MARK: Batch delete
    func deleteAllData(entity: String, completionHandler: ((_ error: String?) -> Void)) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context?.execute(batchDeleteRequest)
            completionHandler(nil)
        } catch {
            completionHandler(error.localizedDescription)
        }
    }
}
