//
//  ViewController.swift
//  DeliveryApp
//
//  Created by Kunal on 14/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    // MARK: Variables
    fileprivate var deliveryTableView = UITableView()
    fileprivate var itemsArray: [ItemModel] = []
    fileprivate var selectedItem: ItemModel?
    fileprivate var refreshControl = UIRefreshControl()
    fileprivate var fetchingMore = false
    fileprivate var isAppended = false
    fileprivate let cellIdentifier = "itemsCell"
    fileprivate let titleName = "Things to Deliver"
    fileprivate let pullToRefreshString = "Pull to refresh"
    fileprivate let dataErrorTitle = "Data Error"
    fileprivate let dataErrorMessage = "Unable to fetch data."
    fileprivate let internetErrorTitle = "No Internet"
    fileprivate let internetErrorMessage = "Check your internet connection."
    fileprivate let entityName = "Item"
    fileprivate let initialOffset = 0

    var container: UIView!
    var loadingView: UIView!
    var activityIndicator: UIActivityIndicatorView!
    
     // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        addElements()
        addConstraints()
        
        deliveryTableView.delegate = self
        deliveryTableView.dataSource = self
        
        self.title = titleName
        
        deliveryTableView.register(ItemsCell.self, forCellReuseIdentifier: cellIdentifier)
        
        deliveryTableView.estimatedRowHeight = 100
        deliveryTableView.rowHeight = UITableView.automaticDimension
        
        showActivityIndicator()
        checkData(offset: 0, isAppended: false) { _ in }
    }
    
    func convertToModel(coreModel: Item, completion: (_ localData: ItemModel) -> Void) {
        let itemModel =  ItemModel()
        
        itemModel.itemId = Int(coreModel.id)
        itemModel.desc = coreModel.desc
        itemModel.imageUrl = coreModel.imageUrl
        
        let location = LocationModel(address: coreModel.address ?? "", lat: coreModel.latitude, lng: coreModel.longitude)
        itemModel.location = location
        
        completion(itemModel)
    }
    
    func checkData(offset: Int, isAppended: Bool, completion: @escaping ((_ completed: Bool) -> Void)) {
        CoreDataService.instance.fetchLocalData(offset: offset) { (_, localData)  in
            if localData.isEmpty {
                print("Fetching from API.")
                getApiData(offset: offset, isAppended: isAppended) { completed in
                    if completed {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            } else {
                print("Fetching from local data.")
                getLocalData(localData: localData, isAppended: isAppended) { completed in
                    if completed {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    func getApiData(offset: Int, isAppended: Bool, completion: @escaping ((_ completed: Bool) -> Void)) {
        guard Connectivity.isConnectedToInternet else {
            self.stopActivityIndicator()
            self.showAlert(alertTitle: internetErrorTitle, alertMessage: internetErrorMessage)
            return
        }
        
        DataService.instance.fetchData(offset: offset) { (res, items)  in
            if res {
                if isAppended {
                    self.itemsArray.append(contentsOf: items)
                } else {
                    self.itemsArray = items
                }
                print("Items count after fetching data:", self.itemsArray.count)
                self.deliveryTableView.reloadData()
                CoreDataService.instance.saveLocalData(item: items)
                self.stopActivityIndicator()
                completion(true)
            } else {
                self.stopActivityIndicator()
                self.showAlert(alertTitle: self.dataErrorTitle, alertMessage: self.dataErrorMessage)
                completion(true)
            }
        }
    }
    
    func getLocalData(localData: [Item], isAppended: Bool, completion: ((_ completed: Bool) -> Void)) {
        var itemsData: [ItemModel] = []
        for data in localData {
            convertToModel(coreModel: data, completion: { (itemModel) in
                itemsData.append(itemModel)
            })
        }
        if isAppended {
            self.itemsArray.append(contentsOf: itemsData)
        } else {
            self.itemsArray = itemsData
        }
        self.deliveryTableView.reloadData()
        self.stopActivityIndicator()
        completion(true)
    }
    
    func showAlert(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActivityIndicator() {
        addActivityIndicator()
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        self.view.addSubview(container)
        
        addActivityIndicatorConstraints()
        
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        self.view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        loadingView.removeFromSuperview()
        container.removeFromSuperview()
    }
    
    func addElements() {
        deliveryTableView = {
            let tableView = UITableView()
            tableView.separatorStyle = .none
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        
        refreshControl.attributedTitle = NSAttributedString(string: pullToRefreshString)
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        deliveryTableView.refreshControl = refreshControl
        
        view.addSubview(deliveryTableView)
    }
    
    func addConstraints() {
        deliveryTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        deliveryTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        deliveryTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        deliveryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func addActivityIndicator() {
        container = UIView()
        container.backgroundColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 0.4)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        loadingView = UIView()
        loadingView.backgroundColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 0.4)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }

    func addActivityIndicatorConstraints() {
        container.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        loadingView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc func refresh() {
        CoreDataService.instance.deleteAllData(entity: entityName)
        //itemsArray = []
        checkData(offset: 0, isAppended: false) { completed in
            if completed {
                self.deliveryTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ItemsCell else {
            return UITableViewCell()
        }
        
        //cell.layer.borderWidth = CGFloat(8)
        //cell.layer.borderColor = tableView.backgroundColor?.cgColor
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        
        cell.selectionStyle = .none
        cell.update(itemModel: itemsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = ItemDetailsVC()
    
        detailVC.getDetails(item: itemsArray[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && !fetchingMore {
            fetchingMore = true
            let footerView = UIView()
            footerView.translatesAutoresizingMaskIntoConstraints = true
            footerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            
            let spinner = UIActivityIndicatorView(style: .whiteLarge)
            spinner.color = .black
            spinner.startAnimating()
            footerView.addSubview(spinner)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
            spinner.heightAnchor.constraint(equalToConstant: 90).isActive = true
            spinner.widthAnchor.constraint(equalTo: footerView.widthAnchor).isActive = true
            deliveryTableView.tableFooterView = footerView
            deliveryTableView.tableFooterView?.isHidden = false
            
            print("Items count before loading more data:", itemsArray.count)
            self.checkData(offset: self.itemsArray.count, isAppended: true) { completed in
                if completed {
                    print("Items count after loading more data:", self.itemsArray.count)
                    self.fetchingMore = false
                    self.deliveryTableView.tableFooterView = UIView()
                    self.deliveryTableView.tableFooterView?.isHidden = true
                }
            }
        }
    }
}
