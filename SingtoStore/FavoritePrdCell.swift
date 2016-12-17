//
//  FavoritePrdCell.swift
//  SingtoStore
//
//  Created by li qiang on 12/10/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//
import UIKit

class FavroitPrdCell: UITableViewCell {
    
    var prd: FavoriteProduct? {
        didSet {
            name.text = prd?.pName!
            name.font = UIFont(name: "AppleSDGothicNeo-Light", size: frame.width / 20)
            let prices = Double((prd?.pPrice)!)
            price.text = "THB \(prices!)"
            price.font = UIFont(name: "AppleSDGothicNeo-Light", size: frame.width / 25)
            if let imgUrl = URL(string: (prd?.pMainImages?[0])!) {
                profileImageView.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "placeholder48"))
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let name: UILabel = {
        let lb = UILabel()
        return lb
    }()
    
    let price: UILabel = {
        let lb = UILabel()
        lb.textColor = Tools.dancingShoesColor
        return lb
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 0).isActive = true
        name.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        name.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -6).isActive = true
        
        addSubview(price)
        price.translatesAutoresizingMaskIntoConstraints = false
        price.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4).isActive = true
        price.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        price.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -6).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
