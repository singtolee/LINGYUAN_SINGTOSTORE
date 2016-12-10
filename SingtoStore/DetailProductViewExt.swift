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
    
    
    func likeorUnlikeBtn() {
        if isUserLogedin() {
            let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
            ref.child("FavoritePRD").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(self.prdKey!) {
                    //use dispatchMain() caused dead lock
                    self.likeButton.setImage(UIImage(named: "like"), for: .normal)
                } else {
                    self.likeButton.setImage(UIImage(named: "unlike"), for: .normal)
                }
            })
        }
    }
    
    func handleLikeClick() {
        if isUserLogedin() {
            let ref = FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
            ref.child("FavoritePRD").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(self.prdKey!) {
                    // liked already, remove this prdKey frome list
                    ref.child("FavoritePRD").child(self.prdKey!).removeValue()
                    self.likeButton.setImage(UIImage(named: "unlike"), for: .normal)
                } else {
                    //not liked yet, like this prd
                    ref.child("FavoritePRD").child(self.prdKey!).setValue(true)
                    self.likeButton.setImage(UIImage(named: "like"), for: .normal)
                }
            
            })
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
