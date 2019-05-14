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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addElements()
        addConstraints()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)

    }
    
    func addElements() {
        
        mapView = {
            let view = UIView()
            view.backgroundColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        itemView = {
            let view = UIView()
            view.backgroundColor = .white
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
        
        itemView.addSubview(itemImageView)
        itemView.addSubview(itemDescription)
        view.addSubview(mapView)
        view.addSubview(itemView)
        
    }
    
    func addConstraints() {
        
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        
        itemView.topAnchor.constraint(equalTo: mapView.topAnchor).isActive = true
        itemView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        itemView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        itemView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        itemImageView.topAnchor.constraint(equalTo: itemView.topAnchor).isActive = true
        itemImageView.leftAnchor.constraint(equalTo: itemView.leftAnchor).isActive = true
        itemImageView.bottomAnchor.constraint(equalTo: itemView.bottomAnchor).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        itemDescription.topAnchor.constraint(equalTo: itemImageView.topAnchor).isActive = true
        itemDescription.leftAnchor.constraint(equalTo: itemImageView.rightAnchor).isActive = true
        itemDescription.bottomAnchor.constraint(equalTo: itemImageView.bottomAnchor).isActive = true
        itemDescription.rightAnchor.constraint(equalTo: itemImageView.rightAnchor).isActive = true
        
    }
    
}
