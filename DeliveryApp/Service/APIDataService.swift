//
//  APIDataService.swift
//  DeliveryApp
//
//  Created by Kunal on 21/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class APIDataService {
    
    static let instance = APIDataService()
    
    fileprivate let serverUrl = "https://mock-api-mobile.dev.lalamove.com/deliveries"
    fileprivate let offsetKey = "offset"
    fileprivate let limitKey = "limit"
    
    func fetchData(offset: Int, completionHandler: @escaping ((_ isResponse: Bool, _ error: String?, _ itemArray: [ItemModel]?) -> Void)) {
        let parameters: [String: Any] = [offsetKey: offset, limitKey: Constants.instance.limit]
        Alamofire.request(serverUrl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.value != nil {
                guard let data = response.result.value! as? [[String: Any]] else { return }
                let items = Mapper<ItemModel>().mapArray(JSONArray: data)
                completionHandler(true, nil, items)
            } else {
                let error = response.error?.localizedDescription
                completionHandler(false, error, nil)
            }
        }
    }
}
