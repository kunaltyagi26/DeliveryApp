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
import ObjectMapper

class DataService {
    
    static let instance = DataService()
    
    fileprivate let baseUrl = "https://mock-api-mobile.dev.lalamove.com/deliveries"
    fileprivate let limit = 20
    fileprivate let offsetKey = "offset"
    fileprivate let limitKey = "limit"
    
    func fetchData(offset: Int, completionHandler: @escaping ((_ isResponse: Bool, _ error: String?, _ itemArray: [ItemModel]) -> Void)) {
        let parameters: [String: Any] = [offsetKey: offset, limitKey: limit]
        Alamofire.request(baseUrl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.value != nil {
                guard let data = response.result.value! as? [[String: Any]] else { return }
                let items = Mapper<ItemModel>().mapArray(JSONArray: data)
                completionHandler(true, nil, items)
            } else {
                let error = response.error?.localizedDescription
                completionHandler(false, error, [ItemModel]())
            }
        }
    }
}
