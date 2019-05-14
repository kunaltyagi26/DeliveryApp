//
//  ItemsCellTableViewCell.swift
//  DeliveryApp
//
//  Created by Kunal on 14/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import UIKit

class ItemsCell: UITableViewCell {

    var itemView = UIView()
    var itemImageView = UIImageView()
    var itemDescription = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addElements()
        addConstraints()
    }
    
    func addElements() {
        
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
        contentView.addSubview(itemView)
    }
    
    func addConstraints() {
        
        itemView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        itemView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        itemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        itemView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        itemImageView.topAnchor.constraint(equalTo: itemView.topAnchor).isActive = true
        itemImageView.leftAnchor.constraint(equalTo: itemView.leftAnchor).isActive = true
        itemImageView.bottomAnchor.constraint(equalTo: itemView.bottomAnchor).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        itemDescription.topAnchor.constraint(equalTo: itemView.topAnchor).isActive = true
        itemDescription.leftAnchor.constraint(equalTo: itemImageView.rightAnchor).isActive = true
        itemDescription.bottomAnchor.constraint(equalTo: itemView.bottomAnchor).isActive = true
        itemDescription.rightAnchor.constraint(equalTo: itemView.rightAnchor).isActive = true
        
    }

}
