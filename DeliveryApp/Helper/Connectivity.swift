//
//  Connectivity.swift
//  DeliveryApp
//
//  Created by Kunal on 17/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
