//
//  CartEmptyState.swift
//  SingtoStore
//
//  Created by li qiang on 2/11/2560 BE.
//  Copyright © 2560 Singto. All rights reserved.
//

import UIKit

class CartEmptyState: UIView {
//    let img: UIImageView = {
//        let image = UIImageView()
//        image.image = UIImage(named: "cart")
//        //image.tintColor = UIColor.lightGray
//        image.backgroundColor = UIColor.lightGray
//        return image
//    }()
    
    let title: UILabel = {
        let lb = UILabel()
        lb.text = "Nothing here"
        lb.textAlignment = .center
        lb.textColor = UIColor.lightGray
        lb.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        return lb
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        addSubview(img)
//        backgroundColor = UIColor.white
//        img.translatesAutoresizingMaskIntoConstraints = false
//        img.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        img.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        //title.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 10).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

}
