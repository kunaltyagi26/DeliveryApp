//
//  Theme.swift
//  DeliveryApp
//
//  Created by Kunal on 16/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import UIKit

class Theme {
    static let instance = Theme()
    
    func changeFont() {
        let font = UIFont(name: "Helvetica Neue", size: 22)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: font as Any]
    }
}