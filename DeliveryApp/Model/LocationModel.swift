//
//  LocationModel.swift
//  DeliveryApp
//
//  Created by Kunal on 15/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import Foundation
import ObjectMapper

class LocationModel: Mappable {
    var address: String?
    var lat: Double?
    var lng: Double?
    
    required init?(map: Map) {
        //For initialization
    }
    
    init(address: String, lat: Double, lng: Double) {
        self.address = address
        self.lat = lat
        self.lng = lng
    }
    
    func mapping(map: Map) {
        address <- map["address"]
        lat <- map["lat"]
        lng <- map["lng"]
    }
}
