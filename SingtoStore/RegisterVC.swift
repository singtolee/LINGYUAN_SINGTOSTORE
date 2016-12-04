//
//  RegisterVC.swift
//  SingtoStore
//
//  Created by li qiang on 12/3/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class RegisterWithEmail: UIViewController, UITextFieldDelegate {
    
    let cancelRegisterBtn = UIButton()
    let inputEmailTF = UITextField()
    let emailBottomLine = UIView()
    let inputPasswordTF = UITextField() //later need to disable paste function
    let passwordBottomLine = UIView()
    let registerAccountBtn = UIButton()
    let offset: CGFloat = 24.0
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegate
        self.inputPasswordTF.delegate = self
        self.inputPasswordTF.clearButtonMode = .whileEditing
        self.inputEmailTF.delegate = self
        self.inputEmailTF.clearButtonMode = .whileEditing
        self.view.backgroundColor = UIColor.white
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(allTextFieldsResignFirstResponder)))
        self.view.isUserInteractionEnabled = true
        setupCancelRegisterBtn()
        setUpInputEmailTextField()
        setUpEmailBottomLine()
        setUpInputPasswordTextField()
        setUpPasswordBottomLine()
        setUpRegisterButton()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    func setupCancelRegisterBtn() {
        self.view.addSubview(cancelRegisterBtn)
        self.cancelRegisterBtn.setImage(UIImage(named: "cancelLogin"), for: UIControlState())
        cancelRegisterBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelRegisterBtn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        cancelRegisterBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        cancelRegisterBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        cancelRegisterBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        self.cancelRegisterBtn.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
    }
    
    
    func setUpInputEmailTextField() {
        self.view.addSubview(inputEmailTF)
        self.inputEmailTF.keyboardType = .emailAddress
        self.inputEmailTF.adjustsFontSizeToFitWidth = true
        self.inputEmailTF.autocorrectionType = .no
        self.inputEmailTF.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        self.inputEmailTF.textColor = UIColor.lightGray
        self.inputEmailTF.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        self.inputEmailTF.returnKeyType = .next
        let imageView = UIImageView()
        imageView.image = UIImage(named: "email")
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        inputEmailTF.leftView = imageView
        inputEmailTF.leftViewMode = UITextFieldViewMode.always
        
        inputEmailTF.translatesAutoresizingMaskIntoConstraints = false
        inputEmailTF.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        inputEmailTF.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: offset).isActive = true
        inputEmailTF.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -offset).isActive = true
        inputEmailTF.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
    }
    func setUpEmailBottomLine() {
        self.view.addSubview(emailBottomLine)
        self.emailBottomLine.backgroundColor = UIColor.lightGray
        
        emailBottomLine.translatesAutoresizingMaskIntoConstraints = false
        emailBottomLine.topAnchor.constraint(equalTo: inputEmailTF.bottomAnchor).isActive = true
        emailBottomLine.leftAnchor.constraint(equalTo: self.inputEmailTF.leftAnchor).isActive = true
        emailBottomLine.rightAnchor.constraint(equalTo: self.inputEmailTF.rightAnchor).isActive = true
        emailBottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func setUpInputPasswordTextField() {
        self.view.addSubview(inputPasswordTF)
        self.inputPasswordTF.isSecureTextEntry = true
        self.inputPasswordTF.attributedPlaceholder = NSAttributedString(string: "Password(at least 6 chars)", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        self.inputPasswordTF.textColor = UIColor.lightGray
        self.inputPasswordTF.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        self.inputPasswordTF.returnKeyType = .done
        let imageView = UIImageView()
        imageView.image = UIImage(named: "lock")
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        inputPasswordTF.leftView = imageView
        inputPasswordTF.leftViewMode = UITextFieldViewMode.always
        
        inputPasswordTF.translatesAutoresizingMaskIntoConstraints = false
        inputPasswordTF.topAnchor.constraint(equalTo: self.inputEmailTF.bottomAnchor, constant: 10).isActive = true
        inputPasswordTF.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: offset).isActive = true
        inputPasswordTF.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -offset).isActive = true
        inputPasswordTF.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
    }
    func setUpPasswordBottomLine() {
        self.view.addSubview(passwordBottomLine)
        self.passwordBottomLine.backgroundColor = UIColor.lightGray
        
        passwordBottomLine.translatesAutoresizingMaskIntoConstraints = false
        passwordBottomLine.topAnchor.constraint(equalTo: inputPasswordTF.bottomAnchor).isActive = true
        passwordBottomLine.leftAnchor.constraint(equalTo: self.inputPasswordTF.leftAnchor).isActive = true
        passwordBottomLine.rightAnchor.constraint(equalTo: self.inputPasswordTF.rightAnchor).isActive = true
        passwordBottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func setUpRegisterButton() {
        self.view.addSubview(registerAccountBtn)
        self.registerAccountBtn.setTitle("REGISTER", for: UIControlState())
        self.registerAccountBtn.titleLabel!.font =  UIFont(name: "ArialRoundedMTBold", size: 18)
        self.registerAccountBtn.setTitleColor(Tools.bgColor, for: .disabled)
        self.registerAccountBtn.layer.cornerRadius = 4
        self.registerAccountBtn.backgroundColor = Tools.dancingShoesColor //Indian red
        
        registerAccountBtn.translatesAutoresizingMaskIntoConstraints = false
        registerAccountBtn.topAnchor.constraint(equalTo: self.inputPasswordTF.bottomAnchor, constant: 20).isActive = true
        registerAccountBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: offset).isActive = true
        registerAccountBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -offset).isActive = true
        self.registerAccountBtn.addTarget(self, action: #selector(onRegisterBtnClicked), for: .touchUpInside)
    }
    func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //called when register button clicked
    func onRegisterBtnClicked() {
        //first chcek all the textfields are filled and correct.
        if Tools.isEmail(Tools.trim(self.inputEmailTF.text!)) && Tools.trim(self.inputPasswordTF.text!).characters.count >= 6 {
            //go to register
            //register account and CANCEL uploading user avatar
            //show registering spin and stop when registration success
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            SVProgressHUD.show(withStatus: "Registering...")
            guard let email = inputEmailTF.text, let pswd = inputPasswordTF.text
                else {return}
            FIRAuth.auth()?.createUser(withEmail: Tools.trim(email), password: Tools.trim(pswd), completion: {(user: FIRUser?, error) in
                if error != nil {
                    SVProgressHUD.dismiss()
                    //display error message
                    let errorEmailAlertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {(_: UIAlertAction) -> Void in}
                    errorEmailAlertController.addAction(okAction)
                    self.present(errorEmailAlertController, animated: true, completion: nil)
                    return}
                //guard let uid = user?.uid else {return}
                //let values = ["email": Tools.trim(email)]
                //Tools.registerUserIntoDatabaseWithUID(uid, values: values)
                SVProgressHUD.dismiss()
                //send email verification
                FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: {(error) in
                    if error != nil {
                        print(error?.localizedDescription)
                        return
                    }
                })
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            //shaking textfield
            if !Tools.isEmail(Tools.trim(self.inputEmailTF.text!)) {
                Tools.shakingUIView(inputEmailTF)
            }
            else if (Tools.trim(self.inputPasswordTF.text!).characters.count < 6) {
                Tools.shakingUIView(inputPasswordTF)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.inputEmailTF {
            self.inputPasswordTF.becomeFirstResponder()
        } else if (textField == self.inputPasswordTF) {
            self.inputPasswordTF.resignFirstResponder()
        }
        return true
    }
    
    func allTextFieldsResignFirstResponder() {
        self.inputEmailTF.resignFirstResponder()
        self.inputPasswordTF.resignFirstResponder()
    }
}
