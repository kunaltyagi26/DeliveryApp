//
//  HomeVCExtensionForApi.swift
//  DeliveryApp
//
//  Created by Kunal on 21/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import Foundation

extension HomeVC {
    func getApiData(offset: Int, completion: @escaping ((_ completed: Bool, _ error: String?, _ localData: [ItemModel]?) -> Void)) {
        APIDataService.instance.fetchData(offset: offset) { (completed, errorMsg, items)   in
            if completed {
                completion(true, nil, items ?? [ItemModel]())
            } else {
                completion(false, errorMsg, nil)
            }
        }
    }
    
    func fetchingAPIData(offset: Int, isAppended: Bool, completion: @escaping ((_ completed: Bool, _ errorMsg: String?, _ items: [ItemModel]?) -> Void)) {
        guard Connectivity.isConnectedToInternet else {
            stopLoader()
            self.showAlert(alertTitle: internetErrorTitle, alertMessage: internetErrorMessage)
            return
        }
        
        getApiData(offset: offset) { completed, errorMsg, items in
            if completed {
                completion(true, nil, items)
            } else {
                completion(false, errorMsg, nil)
            }
        }
    }
}
