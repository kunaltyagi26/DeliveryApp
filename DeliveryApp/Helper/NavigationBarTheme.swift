//
//  NavigationBarTheme.swift
//  DeliveryApp
//
//  Created by Kunal on 16/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import UIKit

class NavigationBarTheme {
    static let instance = NavigationBarTheme()
    
    func changeFont() {
        let font = UIFont(name: Constants.instance.fontFamily, size: Constants.instance.fontSize)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: font as Any]
    }
}
