//
//  ViewController.swift
//  DeliveryApp
//
//  Created by Kunal on 14/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    fileprivate var deliverTableView = UITableView()
    fileprivate var itemsArray: [ItemModel] = []
    fileprivate var selectedItem: ItemModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        addElements()
        addConstraints()
        
        deliverTableView.delegate = self
        deliverTableView.dataSource = self
        
        self.title = "Things to Deliver"
        
        deliverTableView.register(UITableViewCell.self, forCellReuseIdentifier: "itemsCell")
        
        deliverTableView.estimatedRowHeight = 100
        deliverTableView.rowHeight = UITableView.automaticDimension
        
        DataService.instance.fetchLocalData { (localData) in
            if localData.count > 0 {
                //self.itemsArray = localData
            } else {
                DataService.instance.fetchData(offset: 0) { (items) in
                    for item in items {
                        self.itemsArray.append(item)
                    }
                    self.deliverTableView.reloadData()
                }
            }
        }
    }
    
    func addElements() {
        deliverTableView = {
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        
        view.addSubview(deliverTableView)
    }
    
    func addConstraints() {
        deliverTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        deliverTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        deliverTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        deliverTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailView" {
            let detailView = segue.destination as! ItemDetailsVC
            detailView.selectedItem = self.selectedItem
        }
    }

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCell") as? ItemsCell else { return UITableViewCell() }
        cell.update(itemModel: itemsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = itemsArray[indexPath.row]
        performSegue(withIdentifier: "DetailView", sender: self)
    }
    
}

