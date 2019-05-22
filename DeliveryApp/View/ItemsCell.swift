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
            view.layer.borderWidth = borderWidth
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
            label.font = UIFont(name: fontFamily, size: fontSize)
            label.numberOfLines = numberOfLines
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
    
    // MARK: Update value of items
    func update(desc: String, imageUrl: String, address: String) {
        self.itemDescription.text = "\(desc) at \(address)"
        self.itemImageView.af_setImage(withURL: URL(string: imageUrl)!)
    }
    
}
