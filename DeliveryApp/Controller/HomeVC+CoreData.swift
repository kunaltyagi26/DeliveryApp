//
//  HomeVCExtensionForCoreData.swift
//  DeliveryApp
//
//  Created by Kunal on 21/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import Foundation

// MARK: Extension for Core Data
extension HomeVC {
    func fetchDataFromLocal(offset: Int, completion: (_ error: String?, _ localData: [Item]?) -> Void) {
        coreDataService.fetchLocalData(offset: offset) { (errorMsg, localData) in
            if errorMsg == nil {
                completion(nil, localData)
            } else {
                completion(errorMsg, nil)
            }
        }
    }
    
    func saveLocalData(items: [ItemModel], completion: @escaping ((_ errorMsg: String?) -> Void)) {
        self.coreDataService.saveLocalData(item: items ) { errorMsg in
            if errorMsg == nil {
                completion(nil)
            } else {
                self.showAlert(alertTitle: self.dataErrorTitle, alertMessage: errorMsg ?? "")
                completion(errorMsg)
            }
        }
    }
    
    func convertLocalData(localData: [Item], isAppended: Bool, completion: ((_ completed: Bool, _ items: [ItemModel]) -> Void)) {
        var itemsData: [ItemModel] = []
        for data in localData {
            convertToModel(coreModel: data, completion: { (itemModel) in
                itemsData.append(itemModel)
            })
        }
        
        completion(true, itemsData)
    }
}
