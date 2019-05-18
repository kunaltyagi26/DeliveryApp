//
//  CoreDataService.swift
//  DeliveryApp
//
//  Created by Kunal on 16/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import UIKit
import CoreData

class CoreDataService {
    static let instance = CoreDataService()
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    fileprivate let entityName = "Item"
    fileprivate let limit = 20
    
    func saveLocalData(item: [ItemModel]) {
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
            } catch {
                //print("Could not save: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchLocalData(offset: Int, completion: (_ isResponse: Bool, _ localData: [Item]) -> Void) {
        let fetchRequest = NSFetchRequest<Item>(entityName: entityName)
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = limit
        var data = [Item]()
        do {
            data = try context?.fetch(fetchRequest) ?? []
            completion(true, data)
        } catch {
            //print("Could not fetch: \(error.localizedDescription)")
            completion(false, data)
        }
    }
    
    func deleteAllData(entity: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context?.execute(batchDeleteRequest)
        } catch {
            //print(error.localizedDescription)
        }
    }
}
