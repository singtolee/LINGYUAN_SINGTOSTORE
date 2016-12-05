//
//  AddPostAddress.swift
//  SingtoStore
//
//  Created by li qiang on 12/4/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AddPostAddress: DancingShoesViewController, UITextFieldDelegate, UITextViewDelegate {
    let recipientTF = UITextField()
    let phoneTF = UITextField()
    let postCode = UITextField()
    let detailAddressTF = UITextView()
    let saveBTN = UIButton()
    let scrollView = UIScrollView(frame: UIScreen.main.bounds)
    let indicator = UIActivityIndicatorView()
    let placeHolder = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScrollView()
        setUpRecipientTF()
        setUpPhoneTF()
        setupPostCodeTF()
        setUpDetailAddressTF()
        addPlaceHolder()
        addBtn()
        setUpActivityIndicator()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(allTextFieldsResignFirstResponder)))
        self.view.isUserInteractionEnabled = true
    }
    
    func addPlaceHolder() {
        placeHolder.text = "DETAIL ADDRESS"
        placeHolder.isHidden = false
        placeHolder.font = UIFont(name: "ArialHebrew-Light", size: 14)
        placeHolder.textColor = Tools.placeHolderColor
        detailAddressTF.addSubview(placeHolder)
        placeHolder.translatesAutoresizingMaskIntoConstraints = false
        placeHolder.leftAnchor.constraint(equalTo: recipientTF.leftAnchor).isActive = true
        placeHolder.centerYAnchor.constraint(equalTo: detailAddressTF.centerYAnchor).isActive = true
    }
    
    func setUpActivityIndicator() {
        view.addSubview(indicator)
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .gray
        indicator.center = view.center
    }
    
    func setScrollView() {
        view.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height*1.0)
    }
    
    func setUpRecipientTF() {
        scrollView.addSubview(recipientTF)
        recipientTF.delegate = self
        recipientTF.placeholder = "RECIPIENT"
        recipientTF.borderStyle = .none
        recipientTF.autocorrectionType = .no
        recipientTF.clearButtonMode = .whileEditing
        recipientTF.returnKeyType = .next
        recipientTF.font = UIFont(name: "ArialHebrew-Light", size: 14)
        recipientTF.translatesAutoresizingMaskIntoConstraints = false
        recipientTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recipientTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        recipientTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        recipientTF.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        recipientTF.heightAnchor.constraint(equalToConstant: 36).isActive = true
        let subLine0 = UIView()
        subLine0.backgroundColor = UIColor.lightGray
        scrollView.addSubview(subLine0)
        subLine0.translatesAutoresizingMaskIntoConstraints = false
        subLine0.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        subLine0.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        subLine0.topAnchor.constraint(equalTo: recipientTF.bottomAnchor).isActive = true
        subLine0.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setUpPhoneTF() {
        scrollView.addSubview(phoneTF)
        phoneTF.delegate = self
        phoneTF.keyboardType = .numberPad
        phoneTF.clearButtonMode = .whileEditing
        phoneTF.placeholder = "PHONE NUMBER"
        phoneTF.borderStyle = .none
        phoneTF.returnKeyType = .next
        phoneTF.font = UIFont(name: "ArialHebrew-Light", size: 14)
        phoneTF.translatesAutoresizingMaskIntoConstraints = false
        phoneTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        phoneTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        phoneTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        phoneTF.topAnchor.constraint(equalTo: recipientTF.bottomAnchor, constant: 10).isActive = true
        phoneTF.heightAnchor.constraint(equalToConstant: 36).isActive = true
        let subLine1 = UIView()
        subLine1.backgroundColor = UIColor.lightGray
        scrollView.addSubview(subLine1)
        subLine1.translatesAutoresizingMaskIntoConstraints = false
        subLine1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        subLine1.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        subLine1.topAnchor.constraint(equalTo: phoneTF.bottomAnchor).isActive = true
        subLine1.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setUpDetailAddressTF() {
        scrollView.addSubview(detailAddressTF)
        detailAddressTF.delegate = self
        detailAddressTF.autocorrectionType = .no
        detailAddressTF.isScrollEnabled = false
        detailAddressTF.returnKeyType = .done
        detailAddressTF.font = UIFont(name: "ArialHebrew-Light", size: 14)
        detailAddressTF.translatesAutoresizingMaskIntoConstraints = false
        detailAddressTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        detailAddressTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        detailAddressTF.topAnchor.constraint(equalTo: postCode.bottomAnchor, constant: 10).isActive = true
        let subLine2 = UIView()
        subLine2.backgroundColor = UIColor.lightGray
        scrollView.addSubview(subLine2)
        subLine2.translatesAutoresizingMaskIntoConstraints = false
        subLine2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        subLine2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        subLine2.topAnchor.constraint(equalTo: detailAddressTF.bottomAnchor).isActive = true
        subLine2.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupPostCodeTF() {
        scrollView.addSubview(postCode)
        postCode.delegate = self
        postCode.keyboardType = .numberPad
        postCode.clearButtonMode = .whileEditing
        postCode.placeholder = "POST CODE"
        postCode.borderStyle = .none
        //postCode.returnKeyType = .Done
        postCode.font = UIFont(name: "ArialHebrew-Light", size: 14)
        postCode.translatesAutoresizingMaskIntoConstraints = false
        postCode.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postCode.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        postCode.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        postCode.topAnchor.constraint(equalTo: phoneTF.bottomAnchor, constant: 10).isActive = true
        postCode.heightAnchor.constraint(equalToConstant: 36).isActive = true
        let subLine3 = UIView()
        subLine3.backgroundColor = UIColor.lightGray
        scrollView.addSubview(subLine3)
        subLine3.translatesAutoresizingMaskIntoConstraints = false
        subLine3.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        subLine3.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        subLine3.topAnchor.constraint(equalTo: postCode.bottomAnchor).isActive = true
        subLine3.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func addBtn() {
        scrollView.addSubview(saveBTN)
        saveBTN.translatesAutoresizingMaskIntoConstraints = false
        saveBTN.backgroundColor = Tools.dancingShoesColor
        saveBTN.layer.cornerRadius = 6
        saveBTN.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        saveBTN.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        saveBTN.topAnchor.constraint(equalTo: detailAddressTF.bottomAnchor, constant: 30).isActive = true
        saveBTN.heightAnchor.constraint(equalToConstant: 36)
        saveBTN.setTitle("SAVE ADDRESS", for: UIControlState())
        saveBTN.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 18)
        saveBTN.addTarget(self, action: #selector(checkThenAddtoDB), for: .touchUpInside)
    }
    
    func checkThenAddtoDB() {
        let recipient = Tools.trim(recipientTF.text!)
        let mobile = phoneTF.text!
        let address = detailAddressTF.text!
        let postcode = Tools.trim(postCode.text!)
        if recipient != "" && mobile.characters.count == 10 && address.characters.count > 6 && postcode.characters.count == 5 {
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                indicator.startAnimating()
                //var values: Dictionary = [String: String]()
                var values: Dictionary = [String: String]()
                values["Address"] = address
                values["PostCode"] = postcode
                values["recipient"] = recipient
                values["phone"] = mobile
                //values["defaultAddress"] = isDefaultAddress
                let ref = FIRDatabase.database().reference().child("MailingAddresses").child(uid)
                let addressID = ref.childByAutoId().key
                //values["ID"] = addressID
                ref.child(addressID).updateChildValues(values, withCompletionBlock: {(err, ref) in
                    if err != nil {
                        self.indicator.stopAnimating()
                        //print(err)
                        return}
                    self.indicator.stopAnimating()
                    _ = self.navigationController?.popViewController(animated: true)
                })
            }
        } else {
            if recipient == "" {
                Tools.shakingUIView(recipientTF)
            }
            if mobile.characters.count != 10 {
                Tools.shakingUIView(phoneTF)
            }
            if postcode.characters.count != 5 {
                Tools.shakingUIView(postCode)
            }
            if address.characters.count <= 6 {
                Tools.shakingUIView(detailAddressTF)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if Tools.trim(detailAddressTF.text!).isEmpty {
            //no text entered
            placeHolder.isHidden = false
            
        } else {
            //entered text
            placeHolder.isHidden = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.postCode {
            switch UIScreen.main.bounds.height {
            case 480:
                //self.scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    self.scrollView.contentOffset = CGPoint(x: 0, y: 100)
                })
            case 568:
                //self.scrollView.setContentOffset(CGPoint(x: 0, y: 40), animated: true)
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    self.scrollView.contentOffset = CGPoint(x: 0, y: 80)
                })
            default:
                self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch UIScreen.main.bounds.height {
        case 480:
            //self.scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.scrollView.contentOffset = CGPoint(x: 0, y: 100)
            })
        case 568:
            //self.scrollView.setContentOffset(CGPoint(x: 0, y: 40), animated: true)
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.scrollView.contentOffset = CGPoint(x: 0, y: 80)
            })
        default:
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.recipientTF {
            self.phoneTF.becomeFirstResponder()
        }
        return true
    }
    
    func allTextFieldsResignFirstResponder() {
        self.recipientTF.resignFirstResponder()
        self.phoneTF.resignFirstResponder()
        self.detailAddressTF.resignFirstResponder()
        self.postCode.resignFirstResponder()
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        })
    }
    
}
