//
//  EditUserName.swift
//  SingtoStore
//
//  Created by li qiang on 12/4/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EidtUserName: UIViewController, UITextFieldDelegate {
    
    let nameTF = UITextField()
    let doneBTN = UIButton()
    let uid = FIRAuth.auth()?.currentUser?.uid
    let indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = Tools.dancingShoesColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = "EDIT NAME"
        setUpNameTF()
        setUpDoneBTN()
        setUpActivityIndicator()
        
        
        // Do any additional setup after loading the view.
    }
    
    func setUpNameTF() {
        view.addSubview(nameTF)
        nameTF.backgroundColor = UIColor.white
        nameTF.adjustsFontSizeToFitWidth = true
        nameTF.placeholder = "Name"
        nameTF.delegate = self
        nameTF.clearButtonMode = .whileEditing
        nameTF.borderStyle = .roundedRect
        nameTF.autocorrectionType = .no
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        nameTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        nameTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        nameTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        nameTF.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setUpActivityIndicator() {
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .gray
        indicator.bottomAnchor.constraint(equalTo: nameTF.topAnchor, constant: -10).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setUpDoneBTN() {
        view.addSubview(doneBTN)
        doneBTN.translatesAutoresizingMaskIntoConstraints = false
        doneBTN.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 18)
        doneBTN.topAnchor.constraint(equalTo: nameTF.bottomAnchor, constant: 14).isActive = true
        doneBTN.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        doneBTN.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        doneBTN.heightAnchor.constraint(equalToConstant: 36).isActive = true
        doneBTN.layer.cornerRadius = 4
        doneBTN.setTitle("UPDATE", for: UIControlState())
        doneBTN.backgroundColor = Tools.dancingShoesColor
        doneBTN.addTarget(self, action: #selector(updateUserName), for: .touchUpInside)
    }
    
    func updateUserName() {
        let newName = Tools.trim(nameTF.text!)
        if (newName.characters.count > 0) {
            self.indicator.startAnimating()
            FIRDatabase.database().reference().child("users").child(uid!).updateChildValues(["name": newName]) { (error, ref) in
                if error != nil {
                    self.indicator.stopAnimating()
                    return
                }
                self.indicator.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            Tools.shakingUIView(nameTF)
        }
    }
    
}
