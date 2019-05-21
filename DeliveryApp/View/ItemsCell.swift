//
//  ItemsCellTableViewCell.swift
//  DeliveryApp
//
//  Created by Kunal on 14/05/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import UIKit
import AlamofireImage

class ItemsCell: UITableViewCell {

    // MARK: Variables
    fileprivate var itemView = UIView()
    fileprivate var itemImageView = UIImageView()
    fileprivate var itemDescription = UILabel()
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addElements()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Add elements
    func addElements() {
        itemView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.black.cgColor
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        itemImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }()
        
        itemDescription = {
            let label = UILabel()
            label.font = UIFont(name: Constants.instance.fontFamily, size: Constants.instance.fontSize)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
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
    
    // MARK: Update value of items
    func update(desc: String, imageUrl: String) {
        self.itemDescription.text = desc
        self.itemImageView.af_setImage(withURL: URL(string: imageUrl)!)
    }
    
}
