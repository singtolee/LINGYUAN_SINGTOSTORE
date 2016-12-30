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

class StoryTab: DancingShoesViewController, SwipPrdViewDelegate {
    
    let indicator = MyIndicator()
    
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
    
    let prdRef = FIRDatabase.database().reference().child("AllProduct")
    var allPrds = [DetailProduct]()
    var allCards = [SwipPrdView]()
    var currentIndex: Int = 0
    var bufCards = [SwipPrdView]()
    var MAX = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SINGTOSTORE"
        setUpViews()
        loadAllPrds()
    }
    
    func creatCardAtIndex(index: Int) ->SwipPrdView {
        let v = SwipPrdView()
        v.prd = allPrds[index]
        v.delegate = self
        addView(v: v)
        return v
    }
    func showDetailPrdView(view: SwipPrdView) {
        let vc = DetailProductViewController()
        vc.prdKey = view.prd?.prdKey
        self.navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: true, completion: nil)
    }
    
    func populateCards() {
        if self.allPrds.count > 0 {
            // default 2 cards, in case there are one 1 or no product
            let num = allPrds.count > MAX ? MAX : allPrds.count
            for i in 0 ..< allPrds.count {
                let newCard = creatCardAtIndex(index: i)
                allCards.append(newCard)
                if i < num {
                    bufCards.append(newCard)
                }
            }
            for i in 0 ..< bufCards.count {
                passBtn.isHidden = false
                likeBtn.isHidden = false
                if i > 0 {
                    view.insertSubview(bufCards[i], belowSubview: bufCards[i-1])
                }else {
                    view.addSubview(bufCards[i])
                }
                currentIndex = currentIndex + 1
            }
        }
    }
        
    func loadAllPrds() {
        indicator.startAnimating()
        self.prdRef.observeSingleEvent(of: .value, with: { (snap) in
            self.allPrds.removeAll()
            self.allCards.removeAll()
            self.bufCards.removeAll()
            self.currentIndex = 0
            for child in snap.children {
                if let csnap = child as? FIRDataSnapshot {
                    let dict = csnap.value as? [String: Any]
                    let prd = DetailProduct()
                    prd.prdKey = csnap.key
                    prd.prdName = dict?["productName"] as? String
                    prd.prdSub = dict?["productSubDetail"] as? String
                    let jg = dict?["productPrice"] as? String ?? "9999.0"
                    prd.prdPrice = Double(jg)
                    prd.prdImages = dict?["productImages"] as? [String]
                    self.allPrds.append(prd)
                }
            }
            DispatchQueue.main.async(execute: { 
                self.populateCards()
                self.indicator.stopAnimating()
            })
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
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 24).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 42).isActive = true
        view.addSubview(passBtn)
        passBtn.translatesAutoresizingMaskIntoConstraints = false
        passBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90).isActive = true
        passBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width/5).isActive = true
        passBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        passBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        passBtn.isHidden = true
        passBtn.addTarget(self, action: #selector(handlePass), for: .touchUpInside)
        
        view.addSubview(likeBtn)
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90).isActive = true
        likeBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width/5).isActive = true
        likeBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        likeBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        likeBtn.isHidden = true
        likeBtn.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
    }
    
    func like_addNewSubView() {
        bufCards.remove(at: 0)
        if currentIndex < allCards.count {
            bufCards.append(allCards[currentIndex])
            currentIndex = currentIndex + 1
            view.insertSubview(bufCards[MAX - 1], belowSubview: bufCards[MAX - 2])
            bufCards[MAX - 1].topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
            bufCards[MAX - 1].leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        } else {
            bufCards.append(allCards[0])
            currentIndex = 1
            view.insertSubview(bufCards[MAX - 1], belowSubview: bufCards[MAX - 2])
            bufCards[MAX - 1].topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
            bufCards[MAX - 1].leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        }
        
    }
    func pass_addNewSubView() {
        bufCards.remove(at: 0)
        if currentIndex < allCards.count {
            bufCards.append(allCards[currentIndex])
            currentIndex = currentIndex + 1
            view.insertSubview(bufCards[MAX - 1], belowSubview: bufCards[MAX - 2])
            bufCards[MAX - 1].topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
            bufCards[MAX - 1].leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        } else {
            bufCards.append(allCards[0])
            bufCards[0].center = bufCards[1].center
            currentIndex = 1
            view.insertSubview(bufCards[MAX - 1], belowSubview: bufCards[MAX - 2])
            bufCards[MAX - 1].topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
            bufCards[MAX - 1].leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        }
    }
    
    func handleLike(){
        if bufCards.count > 0 {
            likeBtn.isEnabled = true
            UIView.animate(withDuration: 0.4, animations: {
                self.bufCards[0].center.x = self.view.center.x + 500
                self.bufCards[0].center.y = self.view.center.y - 100
                self.bufCards[0].transform = CGAffineTransform(rotationAngle: 0.2)
            }) { (true) in
                self.bufCards[0].transform = CGAffineTransform(rotationAngle: 0)
                self.bufCards[0].removeFromSuperview()
                self.like_addNewSubView()
            }
        } else {
            likeBtn.isEnabled = false
        }
    }
    func handlePass(){
        if bufCards.count > 0 {
            passBtn.isEnabled = true
            UIView.animate(withDuration: 0.4, animations: {
                self.bufCards[0].center.x = self.view.center.x - 700
                self.bufCards[0].center.y = self.view.center.y - 100
                self.bufCards[0].transform = CGAffineTransform(rotationAngle: -0.2)
            }) { (true) in
                self.bufCards[0].transform = CGAffineTransform(rotationAngle: 0)
                self.bufCards[0].removeFromSuperview()
                self.pass_addNewSubView()
            }
        }else {
            passBtn.isEnabled = false
        }
    }
}
