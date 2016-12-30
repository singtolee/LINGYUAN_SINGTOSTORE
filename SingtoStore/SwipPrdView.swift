//
//  SwipPrdView.swift
//  SingtoStore
//
//  Created by li qiang on 12/23/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

protocol SwipPrdViewDelegate {
    func like_addNewSubView()
    func pass_addNewSubView()
    func showDetailPrdView(view: SwipPrdView)
}

import Foundation
import UIKit
import SDWebImage

class SwipPrdView: UIView {
    
    var delegate: SwipPrdViewDelegate!
    let ANG: CGFloat = 0.4
    let ROTMAX = 0.8
    var oP = CGPoint(x: 0, y: 0)
    var oX = CGFloat(0)
    var oY = CGFloat(0)
    
    var prd: DetailProduct? {
        didSet {
            title.text = prd?.prdName
            title.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
            subTitle.text = prd?.prdSub
            subTitle.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
            price.text = "THB \((prd?.prdPrice)!)"
            price.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
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
        lb.text = "PRD TITLE"
        return lb
    }()
    
//    let title: UITextView = {
//        let tv = UITextView()
//        tv.textAlignment = .center
//        tv.text = "I am Title"
//        tv.textColor = UIColor.yellow
//        return tv
//    }()
    
    let subTitle: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.text = "PRD SUB-TITLE"
        lb.textColor = UIColor.gray
        return lb
    }()
    
    let price: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.text = "PRD SUB-TITLE"
        lb.textColor = Tools.dancingShoesColor
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addMainImg()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(pan)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToDetailPrdView)))
    }
    
    func goToDetailPrdView() {
        delegate.showDetailPrdView(view: self)
    }
    
    func handlePan(_ sender: UIPanGestureRecognizer) {
        let offX = sender.translation(in: self).x
        let offY = sender.translation(in: self).y
        
        switch sender.state {
        case .began:
            oX = self.center.x
            oY = self.center.y
            oP = self.center
        case .changed:
            //print("O center: ", oP, "OFF-X", offX, "OFF-Y", offY)
            let alfL = min(offX/150, 1)
            let alfP = min(-offX/150, 1)
            let rotA = min(ANG * offX/360, 1)
            self.passImg.alpha = alfP
            self.likeImg.alpha = alfL
            self.transform = CGAffineTransform(rotationAngle: rotA)
            self.center = CGPoint(x: oX + offX, y: oY + offY)
        case .ended:
            if offX > 150 {
                likeAction(y: offY, p: oP)
            }else if offX < -150 {
                passAction(y: offY)
            } else {
                restoreAction(p: oP)
            }
        default:
            break
        }
    }
    
    func passAction(y: CGFloat){
        let disapperP = CGPoint(x: -500, y: y*2)
        UIView.animate(withDuration: 0.3, animations: {
            self.center = disapperP
        }) { (true) in
            self.transform = CGAffineTransform(rotationAngle: 0)
            self.passImg.alpha = 0
            self.removeFromSuperview()
            self.delegate.pass_addNewSubView()
        }
    }
    func likeAction(y: CGFloat, p: CGPoint){
        let disapperP = CGPoint(x: 500, y: y*2)
        UIView.animate(withDuration: 0.3, animations: {
            self.center = disapperP
        }) { (true) in
            self.transform = CGAffineTransform(rotationAngle: 0)
            self.likeImg.alpha = 0
            self.removeFromSuperview()
            self.delegate.like_addNewSubView()
        }
    }
    func restoreAction(p: CGPoint){
        UIView.animate(withDuration: 0.3) {
            self.center = p
            self.transform = CGAffineTransform(rotationAngle: 0)
            self.likeImg.alpha = 0
            self.passImg.alpha = 0
        }
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
