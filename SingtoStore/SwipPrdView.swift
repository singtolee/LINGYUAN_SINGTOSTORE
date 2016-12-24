//
//  SwipPrdView.swift
//  SingtoStore
//
//  Created by li qiang on 12/23/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class SwipPrdView: UIView {
    var prd: DetailProduct? {
        didSet {
            title.text = prd?.prdName
            title.font = UIFont(name: "AppleSDGothicNeo-Medium", size: self.frame.width/20)
            subTitle.text = prd?.prdSub
            subTitle.font = UIFont(name: "AppleSDGothicNeo-Medium", size: self.frame.width/30)
            price.text = "THB \((prd?.prdPrice)!)"
            price.font = UIFont(name: "AppleSDGothicNeo-Medium", size: self.frame.width/30)
            let url = URL(string: (prd?.prdImages?[0])!)
            mainImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder48"))
        }
    }
    
    let likeImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "like")
        return img
    }()
    
    let passImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "dislike")
        return img
    }()
    
    let mainImgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.image = UIImage(named: "placeholder48")
        return img
    }()
    
    let title: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        //lb.text = "PRD TITLE"
        return lb
    }()
    
    let subTitle: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        //lb.text = "PRD SUB-TITLE"
        lb.textColor = UIColor.gray
        return lb
    }()
    
    let price: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        //lb.text = "PRD SUB-TITLE"
        lb.textColor = Tools.dancingShoesColor
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addMainImg()
    }
    
    
    func addMainImg() {
        addSubview(mainImgView)
        mainImgView.translatesAutoresizingMaskIntoConstraints = false
        mainImgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainImgView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainImgView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainImgView.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: mainImgView.bottomAnchor, constant: 14).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        title.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        //title.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(subTitle)
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.centerYAnchor.constraint(equalTo: mainImgView.bottomAnchor, constant: 30).isActive = true
        subTitle.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        subTitle.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        //subTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(price)
        price.translatesAutoresizingMaskIntoConstraints = false
        price.centerYAnchor.constraint(equalTo: mainImgView.bottomAnchor, constant: 50).isActive = true
        price.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        price.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        mainImgView.addSubview(passImg)
        passImg.translatesAutoresizingMaskIntoConstraints = false
        passImg.topAnchor.constraint(equalTo: mainImgView.topAnchor, constant: 40).isActive = true
        passImg.rightAnchor.constraint(equalTo: mainImgView.rightAnchor, constant: -30).isActive = true
        passImg.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passImg.widthAnchor.constraint(equalToConstant: 50).isActive = true
        passImg.alpha = 0
        
        mainImgView.addSubview(likeImg)
        likeImg.translatesAutoresizingMaskIntoConstraints = false
        likeImg.topAnchor.constraint(equalTo: mainImgView.topAnchor, constant: 40).isActive = true
        likeImg.leftAnchor.constraint(equalTo: mainImgView.leftAnchor, constant: 30).isActive = true
        likeImg.heightAnchor.constraint(equalToConstant: 50).isActive = true
        likeImg.widthAnchor.constraint(equalToConstant: 50).isActive = true
        likeImg.alpha = 0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
