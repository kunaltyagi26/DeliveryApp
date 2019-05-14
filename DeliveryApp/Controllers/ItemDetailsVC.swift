//
//  ItemDetailsVC.swift
//  DeliveryApp
//
//  Created by Kunal on 14/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import UIKit
import GoogleMaps

class ItemDetailsVC: UIViewController {

    var itemView = UIView()
    var itemImageView = UIImageView()
    var itemDescription = UILabel()
    var mapView = UIView()
    var mView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addElements()
        addConstraints()
        
        self.title = "Delivery Details"
        
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
            view.layer.borderWidth = 2.0
            view.layer.borderColor = UIColor.black.cgColor
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        itemImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        itemDescription = {
            let label = UILabel()
            label.font = UIFont(name: "Helvetica Neue", size: 22)
            label.text = "Sample Description."
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
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        
        itemView.topAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        itemView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        itemView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        itemView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        
        itemImageView.topAnchor.constraint(equalTo: itemView.topAnchor).isActive = true
        itemImageView.leftAnchor.constraint(equalTo: itemView.leftAnchor).isActive = true
        itemImageView.bottomAnchor.constraint(equalTo: itemView.bottomAnchor).isActive = true
        itemImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        itemDescription.topAnchor.constraint(equalTo: itemView.topAnchor).isActive = true
        itemDescription.leftAnchor.constraint(equalTo: itemImageView.rightAnchor).isActive = true
        itemDescription.bottomAnchor.constraint(equalTo: itemView.bottomAnchor).isActive = true
        itemDescription.rightAnchor.constraint(equalTo: itemView.rightAnchor).isActive = true
        
    }
    
    func setupMap() {
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView = mView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mView
        
    }
    
}
