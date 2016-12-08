//
//  CellView.swift
//  SingtoStore
//
//  Created by li qiang on 12/6/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
class PrdCell: UICollectionViewCell {
    
    var sprd: ShortProduct? {
        didSet {
            prdPriceLable.text = "THB " + String(describing: sprd!.pPrice!)
            prdPriceLable.font = UIFont(name: "AppleSDGothicNeo-Light", size: frame.width / 12.5)
            prdNameLable.font = UIFont(name: "AppleSDGothicNeo-Light", size: frame.width / 12.5)
            prdNameLable.text = sprd?.pName
            prdSubLable.text = sprd?.pSub
            prdSubLable.font = UIFont(name: "AppleSDGothicNeo-Medium", size: frame.width / 16)
            if let imageUrl = URL(string: sprd!.pMainImage!) {
                prdImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder48"))
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let prdImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let prdNameLable: UILabel = {
        let lab = UILabel()
        return lab
    }()
    let prdSubLable: UILabel = {
        let lab = UILabel()
        return lab
    }()
    
    let prdPriceLable: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.red
        return lab
    }()
    let factor: CGFloat = 0.14
    func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(prdImageView)
        addSubview(prdNameLable)
        addSubview(prdSubLable)
        addSubview(prdPriceLable)
        
        prdImageView.translatesAutoresizingMaskIntoConstraints = false
        prdNameLable.translatesAutoresizingMaskIntoConstraints = false
        prdSubLable.translatesAutoresizingMaskIntoConstraints = false
        prdPriceLable.translatesAutoresizingMaskIntoConstraints = false
        
        prdImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        prdImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        prdImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        prdImageView.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        prdNameLable.topAnchor.constraint(equalTo: prdImageView.bottomAnchor).isActive = true
        prdNameLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        prdNameLable.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4).isActive = true
        prdNameLable.heightAnchor.constraint(equalToConstant: frame.width * factor).isActive = true
        
        prdSubLable.topAnchor.constraint(equalTo: prdNameLable.bottomAnchor).isActive = true
        prdSubLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        prdSubLable.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4).isActive = true
        prdSubLable.heightAnchor.constraint(equalToConstant: frame.width * factor).isActive = true
        
        prdPriceLable.topAnchor.constraint(equalTo: prdSubLable.bottomAnchor).isActive = true
        prdPriceLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
        prdPriceLable.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4).isActive = true
        prdPriceLable.heightAnchor.constraint(equalToConstant: frame.width * factor).isActive = true
    }
}

