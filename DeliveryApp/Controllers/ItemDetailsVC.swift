//
//  ItemDetailsVC.swift
//  DeliveryApp
//
//  Created by Kunal on 14/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import UIKit
import GoogleMaps
import AlamofireImage

class ItemDetailsVC: UIViewController {

    // MARK: Variables
    fileprivate var itemView = UIView()
    fileprivate var itemImageView = UIImageView()
    fileprivate var itemDescription = UILabel()
    fileprivate var mapView = GMSMapView()
    fileprivate var mView: GMSMapView!
    var selectedItem: ItemModel = ItemModel()
    
    // MARK: Constants
    fileprivate let titleName = "Delivery Details"
    fileprivate let descFontFamily = "Helvetica Neue"
    fileprivate let descFontSize: CGFloat = 22
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addElements()
        addConstraints()
        
        self.title = titleName
        
        setupMap()
        updateItemDetails()
    }
    
    // MARK: Add elements
    func addElements() {
        
        mapView = {
            let view = GMSMapView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        itemView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.cornerRadius = 15
            view.clipsToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        itemImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        itemDescription = {
            let label = UILabel()
            label.font = UIFont(name: descFontFamily, size: descFontSize)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        view.backgroundColor = .white
        
        itemView.addSubview(itemImageView)
        itemView.addSubview(itemDescription)
        view.addSubview(mapView)
        view.addSubview(itemView)
    }
    
    func addConstraints() {
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.85).isActive = true
        
        itemView.topAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        itemView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        itemView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        itemView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        itemView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        
        itemImageView.leftAnchor.constraint(equalTo: itemView.leftAnchor, constant: 16).isActive = true
        itemImageView.centerYAnchor.constraint(equalTo: itemView.centerYAnchor).isActive = true
        itemImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        itemDescription.topAnchor.constraint(equalTo: itemView.topAnchor, constant: 16).isActive = true
        itemDescription.leftAnchor.constraint(equalTo: itemImageView.rightAnchor, constant: 16).isActive = true
        itemDescription.bottomAnchor.constraint(equalTo: itemView.bottomAnchor, constant: -16).isActive = true
        itemDescription.rightAnchor.constraint(equalTo: itemView.rightAnchor, constant: -16).isActive = true
    }
    
    // MARK: Fetching details of item
    func getDetails(item: ItemModel) {
        selectedItem.imageUrl = item.imageUrl
        selectedItem.desc = item.desc
        let location = LocationModel(address: item.location?.address ?? "", lat: item.location?.lat ?? 0.0, lng: item.location?.lng ?? 0.0)
        selectedItem.location = location
    }
    
    // MARK: Setting up map
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: selectedItem.location?.lat ?? 0.0, longitude: selectedItem.location?.lng ?? 0.0, zoom: 15.0)
        mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: selectedItem.location?.lat ?? 0.0, longitude: selectedItem.location?.lng ?? 0.0)
        marker.map = mapView
        
    }
    
    // MARK: Update value of item
    func updateItemDetails() {
        self.itemImageView.af_setImage(withURL: URL(string: selectedItem.imageUrl ?? "")!)
        self.itemDescription.text = selectedItem.desc
    }
}
