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

    fileprivate var itemView = UIView()
    fileprivate var itemImageView = UIImageView()
    fileprivate var itemDescription = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addElements()
        addConstraints()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addElements()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addElements() {
        
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
        itemImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        itemDescription.topAnchor.constraint(equalTo: itemView.topAnchor).isActive = true
        itemDescription.leftAnchor.constraint(equalTo: itemImageView.rightAnchor).isActive = true
        itemDescription.bottomAnchor.constraint(equalTo: itemView.bottomAnchor).isActive = true
        itemDescription.rightAnchor.constraint(equalTo: itemView.rightAnchor).isActive = true
        
    }
    
    func update(itemModel: ItemModel) {
        self.itemDescription.text = itemModel.desc
        self.itemImageView.af_setImage(withURL: itemModel.imageUrl)
    }

}
