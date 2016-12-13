//
//  DetailProductViewExt.swift
//  SingtoStore
//
//  Created by li qiang on 12/9/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase
extension DetailProductViewController {
    
    func addToCart() {
        if isUserLogedin() {
            //add prd to cart
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                
                let paths = self.csView.collectionView.indexPathsForSelectedItems
                let path = paths?[0].item
                
                //start adding to cart animation
                self.addCartView()
                UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseIn], animations: {
                    self.cartView.center.x += self.view.bounds.width / 2 - 110
                    self.cartView.center.y -= self.view.bounds.height / 2
                    }, completion: nil)
                var value: Dictionary = [String: Any]()
                value["prdKey"] = self.prdKey!
                value["prdTitle"] = self.product?.prdName
                value["prdPrice"] = self.product?.prdPrice
                value["prdImg"] = self.product?.prdImages?[path!]
                value["prdCS"] = self.product?.prdCS?[path!]
                value["ID"] = path!
                value["Check"] = true
                value["Qty"] = 1
                
                
                //self.userRef.child(uid).child("SHOPPINGCART").childByAutoId().setValue(value)
                
                self.userRef.child(uid).child("SHOPPINGCART").childByAutoId().setValue(value, withCompletionBlock: { (error, refe) in
                    if error != nil {
                        // failed add to cart, display try again hint
                        self.cartView.removeFromSuperview()
                    
                    } else {
                        //remove cart animation
                        self.cartView.removeFromSuperview()
                    }
                })
                
            } else {return}
        } else {
            //go to login
            let loginPage = LoginVC()
            present(loginPage, animated: true, completion: nil)
        }
    
    }
    
    func buyNow() {
        if isUserLogedin() {
            //add prd to cart
            print(1234568888)
        } else {
            //go to login
            let loginPage = LoginVC()
            present(loginPage, animated: true, completion: nil)
        }
    }
    
    func likeorUnlikeBtn() {
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let us = user {
                let ref = self.userRef.child(us.uid).child("FavoritePRD")
                self.loginHandle = ref.observe(.value, with: { (snapshot) in
                    if snapshot.hasChild(self.prdKey!) {
                        //use dispatchMain() caused dead lock
                        DispatchQueue.main.async(execute: {
                            self.likeButton.setImage(UIImage(named: "like"), for: .normal)
                        })
                        //self.likeButton.setImage(UIImage(named: "like"), for: .normal)
                    } else {
                        DispatchQueue.main.async(execute: {
                            self.likeButton.setImage(UIImage(named: "unlike"), for: .normal)
                        })
                        //self.likeButton.setImage(UIImage(named: "unlike"), for: .normal)
                    }
                    
                })
            }
        })
        
        
//        if isUserLogedin() {
//            if let uid = FIRAuth.auth()?.currentUser?.uid {
//                let ref = self.userRef.child(uid).child("FavoritePRD")
//                self.loginHandle = ref.observe(.value, with: { (snapshot) in
//                    if snapshot.hasChild(self.prdKey!) {
//                        //use dispatchMain() caused dead lock
//                        DispatchQueue.main.async(execute: {
//                            self.likeButton.setImage(UIImage(named: "like"), for: .normal)
//                        })
//                        //self.likeButton.setImage(UIImage(named: "like"), for: .normal)
//                    } else {
//                        DispatchQueue.main.async(execute: {
//                            self.likeButton.setImage(UIImage(named: "unlike"), for: .normal)
//                        })
//                        //self.likeButton.setImage(UIImage(named: "unlike"), for: .normal)
//                    }
//                    
//                })
//                
//            } else {return}
//            
//        }
    }
    
    func handleLikeClick() {
        if isUserLogedin() {
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                let ref = self.userRef.child(uid).child("FavoritePRD")
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChild(self.prdKey!) {
                        // liked already, remove this prdKey frome list
                        ref.child(self.prdKey!).removeValue()
                        //self.likeButton.setImage(UIImage(named: "unlike"), for: .normal)
                    } else {
                        //not liked yet, like this prd
                        ref.child(self.prdKey!).setValue(true)
                        //self.likeButton.setImage(UIImage(named: "like"), for: .normal)
                    }
                    
                })
            } else {return}
        } else {
            //display need login message or go to login page
            let loginPage = LoginVC()
            present(loginPage, animated: true, completion: nil)
        }
    }
    
    
    func isUserLogedin() -> Bool {
        if FIRAuth.auth()?.currentUser != nil {
            // User is signed in.
            return true
        } else {
            // No user is signed in.
            return false
        }
    }
}
