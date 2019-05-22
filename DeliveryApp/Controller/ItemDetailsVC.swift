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
    var itemView: UIView!
    var itemImageView: UIImageView!
    fileprivate var itemDescription: UILabel!
    var mapView: GMSMapView!
    var selectedItem: ItemModel = ItemModel()
    
    // MARK: Constants
    fileprivate let titleName = "Delivery Details"
    fileprivate let zoomLevel: Float = 15.0
    fileprivate let cornerRadius: CGFloat = 15
    fileprivate let mapViewHeightMultiplier: CGFloat = 0.85
    fileprivate let itemViewLeftAnchor: CGFloat = 8
    fileprivate let itemViewRightAnchor: CGFloat = -8
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addElements() 
        addConstraints()
        
        self.title = titleName
        
        self.setupMap()
        self.updateItemDetails()
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
            view.layer.borderWidth = borderWidth
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.cornerRadius = cornerRadius
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
            label.font = UIFont(name: fontFamily, size: fontSize)
            label.numberOfLines = numberOfLines
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
        mapView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: mapViewHeightMultiplier).isActive = true
        
        itemView.topAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        itemView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: itemViewLeftAnchor).isActive = true
        itemView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomAnchorValue).isActive = true
        itemView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: itemViewRightAnchor).isActive = true
        itemView.heightAnchor.constraint(greaterThanOrEqualToConstant: heightAnchorValue).isActive = true
        
        itemImageView.leftAnchor.constraint(equalTo: itemView.leftAnchor, constant: leftAnchorValue).isActive = true
        itemImageView.topAnchor.constraint(equalTo: itemView.topAnchor, constant: leftAnchorValue).isActive = true
        itemImageView.bottomAnchor.constraint(equalTo: itemView.bottomAnchor, constant: bottomAnchorValue).isActive = true
        itemImageView.widthAnchor.constraint(equalToConstant: heightAnchorValue).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: heightAnchorValue).isActive = true
        
        itemDescription.topAnchor.constraint(equalTo: itemView.topAnchor, constant: leftAnchorValue).isActive = true
        itemDescription.leftAnchor.constraint(equalTo: itemImageView.rightAnchor, constant: leftAnchorValue).isActive = true
        itemDescription.bottomAnchor.constraint(equalTo: itemView.bottomAnchor, constant: bottomAnchorValue).isActive = true
        itemDescription.rightAnchor.constraint(equalTo: itemView.rightAnchor, constant: bottomAnchorValue).isActive = true
    }
    
    // MARK: Fetching details of item
    func setDetails(item: ItemModel) {
        selectedItem = item
    }
    
    // MARK: Setting up map
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: selectedItem.location?.lat ?? 0.0, longitude: selectedItem.location?.lng ?? 0.0, zoom: zoomLevel)
        mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: selectedItem.location?.lat ?? 0.0, longitude: selectedItem.location?.lng ?? 0.0)
        marker.map = mapView
        marker.title = selectedItem.location?.address
    }
    
    // MARK: Update value of item
    func updateItemDetails() {
        var url = ""
        var address = ""
        var description = ""
        
        if let imageUrl = selectedItem.imageUrl {
            url = imageUrl
        } else {
            url = placeholderImageUrl
        }
        
        if let desc = selectedItem.desc {
            description = desc
        }
        
        if let location = selectedItem.location {
            address = location.address ?? ""
        }
        self.itemImageView.af_setImage(withURL: URL(string: url)!)
        self.itemDescription.text = "\(String(describing: description)) at \(String(describing: address))"
    }
}
