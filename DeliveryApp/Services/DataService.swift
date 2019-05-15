//
//  DataService.swift
//  DeliveryApp
//
//  Created by Kunal on 14/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import CoreData

class DataService {
    
    static let instance = DataService()
    
    fileprivate let baseUrl = "https://mock-api-mobile.dev.lalamove.com/deliveries"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    func fetchData(offset: Int, completionHandler: @escaping ((_ itemArray: [ItemModel]) -> Void)) {
        var itemDetails: [ItemModel] = []
        
        Alamofire.request(baseUrl, method: .get, parameters: ["offset": offset, "limit": 20], encoding: JSONEncoding.default, headers: .none).responseJSON { (response) in
            if response.result.value != nil {
                guard let data = response.result.value! as? [[String: Any]] else { return }
                
                for d in data {
                    let id = d["id"] as! Int
                    let description = d["description"] as! String
                    let imageUrlString = d["imageUrl"] as! String
                    let imageUrl = URL(fileURLWithPath: imageUrlString)
                    
                    guard let location = d["location"] as? [String: Any] else { return }
                    
                    let address = location["address"] as! String
                    let latitude = location["lat"] as! Double
                    let longitude = location["lng"] as! Double
                    
                    let loc = LocationModel(address: address, lat: latitude, lng: longitude)
                    itemDetails.append(ItemModel(id: id, desc: description, imageUrl: imageUrl, location: loc))
                    
                    let item = Item(context: self.context)
                    item.id = Int32(id)
                    item.desc = description
                    item.imageUrl = imageUrl
                    item.latitude = latitude
                    item.longitude = longitude
                    item.address = address
                    
                    do {
                        try self.context.save()
                        print("Data successfully saved.")
                    } catch {
                        print("Could not save: \(error.localizedDescription)")
                    }
                    
                    completionHandler(itemDetails)
                }
            }
        }
    }
    
    func fetchLocalData(completion: (_ localData: [Item])-> ()) {
        let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
        var data = [Item]()
        do {
            data = try context.fetch(fetchRequest)
            completion(data)
        } catch {
            print("Could not fetch: \(error.localizedDescription)")
            completion(data)
        }
    }
}
