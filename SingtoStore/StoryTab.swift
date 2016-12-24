//
//  StoryTab.swift
//  SingtoStore
//
//  Created by li qiang on 12/3/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class StoryTab: DancingShoesViewController {
    //parameters
    let ANG: CGFloat = 0.4
    let ROTMAX = 0.8
    
    let likeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "like"), for: .normal)
        btn.layer.borderColor = Tools.headerColor.cgColor
        btn.layer.borderWidth = 6
        btn.layer.cornerRadius = 30
        return btn
    }()
    
    let passBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "pass"), for: .normal)
        btn.layer.borderColor = Tools.headerColor.cgColor
        btn.layer.borderWidth = 6
        btn.layer.cornerRadius = 30
        return btn
    }()
    
    let swipPrd = SwipPrdView()
    
    let prdRef = FIRDatabase.database().reference().child("AllProduct")
    var allPrds = [DetailProduct]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        loadAllPrds()
        addView(v: swipPrd)
        //set pangestrue
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(viewDidDrag))
        panGesture.maximumNumberOfTouches = 1
        swipPrd.addGestureRecognizer(panGesture)
    }
    
    func viewDidDrag(_ sender: UIPanGestureRecognizer) {
        let x = view.center.x
        let y = view.frame.width/2 + 20
        let oP = CGPoint(x: x, y: y)
        
        let offX = sender.translation(in: view).x
        let offY = sender.translation(in: view).y
        switch sender.state {
        case .changed:
            let alfL = min(offX/150, 1)
            let alfP = min(-offX/150, 1)
            let rotA = min(ANG * offX/360, 1)
            swipPrd.passImg.alpha = alfP
            swipPrd.likeImg.alpha = alfL
            swipPrd.transform = CGAffineTransform(rotationAngle: rotA)
            swipPrd.center = CGPoint(x: oP.x + offX, y: oP.y + offY)
        case .ended:
            if offX > 150 {
                likeAction(y: offY)
            } else if offX < -150 {
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
            self.swipPrd.center = disapperP
            }) { (true) in
                self.swipPrd.removeFromSuperview()
        }
    }
    func likeAction(y: CGFloat){
        let disapperP = CGPoint(x: 500, y: y*2)
        UIView.animate(withDuration: 0.3, animations: {
            self.swipPrd.center = disapperP
        }) { (true) in
            self.swipPrd.removeFromSuperview()
        }
    }
    func restoreAction(p: CGPoint){
        UIView.animate(withDuration: 0.3) { 
            self.swipPrd.center = p
            self.swipPrd.transform = CGAffineTransform(rotationAngle: 0)
            self.swipPrd.likeImg.alpha = 0
            self.swipPrd.passImg.alpha = 0
        }
    }
    
    func loadAllPrds() {
        self.prdRef.observe(.childAdded, with: { (snap) in
            if let dict = snap.value as? [String: Any] {
                let prd = DetailProduct()
                prd.prdName = dict["productName"] as? String
                prd.prdSub = dict["productSubDetail"] as? String
                let jg = dict["productPrice"] as? String ?? "9999.0"
                prd.prdPrice = Double(jg)
                prd.prdImages = dict["productImages"] as? [String]
                prd.prdInfoImages = dict["productInfoImages"] as? [String]
                self.allPrds.append(prd)
                self.swipPrd.prd = self.allPrds[0]
            }
        })
    }
    
    func addView(v: UIView) {
        view.addSubview(v)
        v.backgroundColor = Tools.headerColor
        v.clipsToBounds = true
        v.layer.cornerRadius = 4
        v.translatesAutoresizingMaskIntoConstraints = false
        v.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        v.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        v.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        v.heightAnchor.constraint(equalToConstant: view.frame.width + 20).isActive = true
    }
    
    func setUpViews() {
        view.addSubview(passBtn)
        passBtn.translatesAutoresizingMaskIntoConstraints = false
        passBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90).isActive = true
        passBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width/5).isActive = true
        passBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        passBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        passBtn.addTarget(self, action: #selector(handlePass), for: .touchUpInside)
        
        view.addSubview(likeBtn)
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90).isActive = true
        likeBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width/5).isActive = true
        likeBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        likeBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        likeBtn.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
    }
    func handleLike(){
        UIView.animate(withDuration: 0.4, animations: {
            self.swipPrd.center.x = self.view.center.x + 500
            self.swipPrd.center.y = self.view.center.y - 100
            self.swipPrd.transform = CGAffineTransform(rotationAngle: 0.2)
        }) { (true) in
            self.swipPrd.removeFromSuperview()
        }
    }
    func handlePass(){
        UIView.animate(withDuration: 0.4, animations: {
            self.swipPrd.center.x = self.view.center.x - 700
            self.swipPrd.center.y = self.view.center.y - 100
            self.swipPrd.transform = CGAffineTransform(rotationAngle: -0.2)
        }) { (true) in
            self.swipPrd.removeFromSuperview()
        }
    }
}
