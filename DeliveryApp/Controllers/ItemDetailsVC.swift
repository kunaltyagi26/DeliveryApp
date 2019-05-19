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

    fileprivate var itemView = UIView()
    fileprivate var itemImageView = UIImageView()
    fileprivate var itemDescription = UILabel()
    fileprivate var mapView = GMSMapView()
    fileprivate var mView: GMSMapView!
    fileprivate let titleName = "Delivery Details"
    
    var imageUrl: String?
    var desc: String?
    var latitude: Double?
    var longitude: Double?
    var selectedItem: ItemModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addElements()
        addConstraints()
        
        self.title = titleName
        
        setupMap()
    }
    
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
            label.font = UIFont(name: "Helvetica Neue", size: 22)
            label.text = "Sample Description."
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
        
        self.itemImageView.af_setImage(withURL: URL(string: imageUrl ?? "")!)
        self.itemDescription.text = desc!
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
    
    func setupMap() {
        view.addSubview(mapView)
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude ?? 0.0, longitude: longitude ?? 0.0, zoom: 15.0)
        mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
        marker.map = mapView
        
    }
    
    func getDetails(item: ItemModel) {
        self.imageUrl = item.imageUrl
        self.desc = item.desc
        self.latitude = item.location?.lat
        self.longitude = item.location?.lng
    }
    
}
