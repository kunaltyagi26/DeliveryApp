//
//  ItemModel.swift
//  DeliveryApp
//
//  Created by Kunal on 14/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import Foundation
import ObjectMapper

class ItemModel: Mappable {
    var itemId: Int?
    var desc: String?
    var imageUrl: String?
    var location: LocationModel?
    
    required init?(map: Map) {
        //For initialization
    }
    
    init() {
        //For initialization
    }
    
    func mapping(map: Map) {
        itemId <- map["id"]
        desc <- map["description"]
        imageUrl <- map["imageUrl"]
        location <- map["location"]
    }
}
