//
//  HomeVC.swift
//  DeliveryApp
//
//  Created by Kunal on 14/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: Variables
    var deliveryTableView: UITableView!
    var deliveryItems: [ItemModel] = []
    fileprivate var refreshControl = UIRefreshControl()
    fileprivate var isfetchingMore = false
    var isAppended = false
    var container: UIView!
    var loadingView: UIView!
    var activityIndicator: UIActivityIndicatorView!
    var footerSpinner = UIActivityIndicatorView(style: .whiteLarge)
    let coreDataService = CoreDataService()
    
    // MARK: Constants
    fileprivate let cellIdentifier = "itemsCell"
    fileprivate let titleName = "Things to Deliver"
    fileprivate let pullToRefreshString = "Pull to refresh"
    let dataErrorTitle = "Data Error"
    let internetErrorTitle = "No Internet"
    let internetErrorMessage = "Check your internet connection."
    fileprivate let initialOffset = 0
    fileprivate let numberOfSections = 1
    fileprivate let cellSpacing: CGFloat = 8
    fileprivate let cornerRadius: CGFloat = 10
    fileprivate var estimatedRowHeight: CGFloat = 100
    fileprivate var okAlertTile = "Ok"
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        addElements()
        addConstraints()
        
        deliveryTableView.delegate = self
        deliveryTableView.dataSource = self
        
        self.title = titleName
        
        deliveryTableView.register(ItemsCell.self, forCellReuseIdentifier: cellIdentifier)
        
        deliveryTableView.estimatedRowHeight = estimatedRowHeight
        deliveryTableView.rowHeight = UITableView.automaticDimension
        
        showActivityIndicator()
        fetchData(offset: initialOffset, isAppended: false) { _ in }
    }
    
    // MARK: Add elements
    func addElements() {
        deliveryTableView = {
            let tableView = UITableView()
            tableView.separatorStyle = .none
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        
        refreshControl.attributedTitle = NSAttributedString(string: pullToRefreshString)
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: UIControl.Event.valueChanged)
        deliveryTableView.refreshControl = refreshControl
        
        view.addSubview(deliveryTableView)
    }
    
    func addConstraints() {
        deliveryTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        deliveryTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        deliveryTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        deliveryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: Check for data
    func fetchData(offset: Int, isAppended: Bool, completion: @escaping ((_ completed: Bool) -> Void)) {
        fetchDataFromLocal(offset: offset) { (errorMsg, localData) in
            guard errorMsg == nil else {
                self.showAlert(alertTitle: self.dataErrorTitle, alertMessage: errorMsg ?? "")
                completion(false)
                return
            }
            
            if localData?.isEmpty ?? true {
                fetchingAPIData(offset: offset, isAppended: isAppended) { (_, errorMsg, items) in
                    guard errorMsg == nil else {
                        self.errorWhileFetchingData(errorMsg: errorMsg ?? "")
                        completion(false)
                        return
                    }
                    
                    if isAppended {
                        self.deliveryItems.append(contentsOf: items ?? [ItemModel]())
                    } else {
                        self.deliveryItems = items ?? [ItemModel]()
                    }
                    self.deliveryTableView.reloadData()
                    self.saveLocalData(items: items ?? [ItemModel]()) { errorMsg in
                        if errorMsg == nil {
                            completion(true)
                        } else {
                            self.errorWhileFetchingData(errorMsg: errorMsg ?? "")
                            completion(false)
                        }
                    }
                    self.stopLoader()
                }
            } else {
                convertLocalData(localData: localData ?? [Item](), isAppended: isAppended) { completed in
                   completion(completed)
                }
            }
        }
    }
    
    func errorWhileFetchingData(errorMsg: String) {
        self.showAlert(alertTitle: self.dataErrorTitle, alertMessage: errorMsg )
        self.stopActivityIndicator()
    }
    
    // MARK: Convert core data model to simple model
    func convertToModel(coreModel: Item, completion: (_ localData: ItemModel) -> Void) {
        let itemModel =  ItemModel()
        
        itemModel.itemId = Int(coreModel.id)
        itemModel.desc = coreModel.desc
        itemModel.imageUrl = coreModel.imageUrl
        
        let location = LocationModel(address: coreModel.address ?? "", lat: coreModel.latitude, lng: coreModel.longitude)
        itemModel.location = location
        
        completion(itemModel)
    }
    
    // MARK: Pull to refresh
    @objc func pullToRefresh() {
        self.coreDataService.deleteAllData(entity: Constants.instance.entityName) { (errorMsg) in
            if errorMsg == nil {
                self.fetchData(offset: initialOffset, isAppended: false) { completed in
                    if completed {
                        self.deliveryTableView.reloadData()
                        self.completingRefresh()
                    } else {
                        self.completingRefresh()
                    }
                }
            } else {
                self.completingRefresh()
                self.showAlert(alertTitle: self.dataErrorTitle, alertMessage: errorMsg ?? "")
            }
        }
    }
    
    func completingRefresh() {
        self.isfetchingMore = false
        self.refreshControl.endRefreshing()
    }
    
    // MARK: For showing alerts
    func showAlert(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: okAlertTile, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: Extension for TableView
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ItemsCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        let deliveryItem = deliveryItems[indexPath.row]
        cell.update(desc: deliveryItem.desc ?? "", imageUrl: deliveryItem.imageUrl ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = ItemDetailsVC()
    
        detailVC.setDetails(item: deliveryItems[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && !isfetchingMore {
            isfetchingMore = true
            addFooter()
            loadMore()
        }
    }
}

// MARK: Extension for Activity Indicator
extension HomeVC {
    // MARK: Activity Indicator
    func addActivityIndicator() {
        container = UIView()
        container.backgroundColor = Constants.instance.backgroundColor
        container.translatesAutoresizingMaskIntoConstraints = false
        
        loadingView = UIView()
        loadingView.backgroundColor = Constants.instance.backgroundColor
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = cornerRadius
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
}

// MARK: For pagination
extension HomeVC {
    func addFooter() {
        footerSpinner.color = .black
        footerSpinner.startAnimating()
        footerSpinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: deliveryTableView.bounds.width, height: CGFloat(44))
        
        deliveryTableView.tableFooterView = footerSpinner
        deliveryTableView.tableFooterView?.isHidden = false
    }
    
    func stopLoader() {
        stopActivityIndicator()
        self.footerSpinner.stopAnimating()
        self.deliveryTableView.tableFooterView?.isHidden = true
    }
    
    func loadMore() {
        self.fetchData(offset: self.deliveryItems.count, isAppended: true) { completed in
            if completed {
                self.isfetchingMore = false
                self.stopLoader()
            } else {
                self.isfetchingMore = false
                self.stopLoader()
            }
        }
    }
}