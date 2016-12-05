//
//  EditPhoneNumber.swift
//  SingtoStore
//
//  Created by li qiang on 12/4/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class EditPhoneNumber: UIViewController, UITextFieldDelegate {
    let phoneTF = UITextField()
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
        self.title = "PHONE NUMBER"
        setUpPhoneTF()
        setUpDoneBTN()
        setUpActivityIndicator()
    }
    
    func setUpPhoneTF() {
        view.addSubview(phoneTF)
        phoneTF.translatesAutoresizingMaskIntoConstraints = false
        phoneTF.backgroundColor = UIColor.white
        phoneTF.delegate = self
        phoneTF.placeholder = "Mobile Phone"
        phoneTF.keyboardType = .numberPad
        phoneTF.clearButtonMode = .whileEditing
        phoneTF.borderStyle = .roundedRect
        phoneTF.autocorrectionType = .no
        phoneTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        phoneTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        phoneTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        phoneTF.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setUpActivityIndicator() {
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .gray
        indicator.bottomAnchor.constraint(equalTo: phoneTF.topAnchor, constant: -10).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setUpDoneBTN() {
        view.addSubview(doneBTN)
        doneBTN.translatesAutoresizingMaskIntoConstraints = false
        doneBTN.topAnchor.constraint(equalTo: phoneTF.bottomAnchor, constant: 14).isActive = true
        doneBTN.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        doneBTN.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        doneBTN.heightAnchor.constraint(equalToConstant: 36).isActive = true
        doneBTN.layer.cornerRadius = 4
        doneBTN.setTitle("UPDATE", for: UIControlState())
        doneBTN.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 18)
        doneBTN.backgroundColor = Tools.dancingShoesColor
        doneBTN.addTarget(self, action: #selector(updateUserName), for: .touchUpInside)
    }
    
    func updateUserName() {
        let newPhone = Tools.trim(phoneTF.text!)
        if (newPhone.characters.count == 10) {
            self.indicator.startAnimating()
            FIRDatabase.database().reference().child("users").child(uid!).updateChildValues(["phone": newPhone]) { (error, ref) in
                if error != nil {
                    self.indicator.stopAnimating()
                    return
                }
                self.indicator.stopAnimating()
                _ = self.navigationController?.popViewController(animated: true)
            }
        } else {
            Tools.shakingUIView(phoneTF)
        }
    }
    
}
