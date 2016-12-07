//
//  LoginVC.swift
//  SingtoStore
//
//  Created by li qiang on 12/3/2559 BE.
//  Copyright © 2559 Singto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit
import SVProgressHUD

class LoginVC: UIViewController, UITextFieldDelegate {
    
    let fbLoginBtn = UIButton()
    let cancelLoginBtn = UIButton()
    let emailTF = UITextField()
    let pswd = UITextField()
    let welcomeLable = UILabel()
    let emailLoginBtn = UIButton()
    let orLable = UILabel()
    let registerBtn = UIButton()
    let eLine = UIView()
    let pswdLine = UIView()
    let forgetPasswordBtn = UIButton()
    let offset: CGFloat = 24
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(fbLoginBtn)
        self.view.addSubview(cancelLoginBtn)
        self.view.addSubview(emailTF)
        self.view.addSubview(pswd)
        self.view.addSubview(welcomeLable)
        self.view.addSubview(emailLoginBtn)
        self.view.addSubview(orLable)
        self.view.addSubview(registerBtn)
        self.view.addSubview(eLine)
        self.view.addSubview(pswdLine)
        self.view.addSubview(forgetPasswordBtn)
        self.emailTF.delegate = self
        self.pswd.delegate = self
        setupFacebookSignInBtn()
        setupCancelLogInBtn()
        setUpWelcomeLable()
        setUpEmailTF()
        setUpPasswordTF()
        setUpEmailLogInBtn()
        setUpOrLable()
        setUpRegisterBtn()
        addEmailTFBottomLine()
        addPasswordTFBottomLine()
        setUpForgetPasswordButton()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(allTextFieldsResignFirstResponder)))
        self.view.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //if user loged in, dismiss this view
        if FIRAuth.auth()?.currentUser != nil {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func setupCancelLogInBtn() {
        self.cancelLoginBtn.setImage(UIImage(named: "cancelLogin"), for: UIControlState())
        
        cancelLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelLoginBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/20).isActive = true
        cancelLoginBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        cancelLoginBtn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        cancelLoginBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        self.cancelLoginBtn.addTarget(self, action: #selector(disMisSignInVc), for: .touchUpInside)
        
    }
    
    func setUpWelcomeLable() {
        self.welcomeLable.text = "welcome to aomai"
        self.welcomeLable.font = UIFont(name: "ArialRoundedMTBold", size: 26)
        //set to be at center
        self.welcomeLable.textAlignment = .center
        self.welcomeLable.textColor = UIColor.lightGray
        
        welcomeLable.translatesAutoresizingMaskIntoConstraints = false
        welcomeLable.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/8).isActive = true
        welcomeLable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        welcomeLable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        welcomeLable.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setUpEmailTF() {
        self.emailTF.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        self.emailTF.keyboardType = .emailAddress
        self.emailTF.adjustsFontSizeToFitWidth = true
        self.emailTF.autocorrectionType = .no
        self.emailTF.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        self.emailTF.textColor = UIColor.lightGray
        self.emailTF.returnKeyType = .next
        self.emailTF.clearButtonMode = .whileEditing
        //get NSUserDefaults EMAIL
        let getUserDefault = UserDefaults.standard
        if let savedEmail = getUserDefault.string(forKey: "EMAIL") {
            self.emailTF.text = savedEmail
        }
        //add left icon
        let imageView = UIImageView()
        imageView.image = UIImage(named: "email")
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        emailTF.leftView = imageView
        emailTF.leftViewMode = UITextFieldViewMode.always
        
        emailTF.translatesAutoresizingMaskIntoConstraints = false
        emailTF.topAnchor.constraint(equalTo: welcomeLable.bottomAnchor, constant: view.bounds.height/20).isActive = true
        emailTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: offset).isActive = true
        emailTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -offset).isActive = true
        emailTF.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    func addEmailTFBottomLine(){
        self.eLine.backgroundColor = UIColor.lightGray
        
        eLine.translatesAutoresizingMaskIntoConstraints = false
        eLine.topAnchor.constraint(equalTo: emailTF.bottomAnchor).isActive = true
        eLine.leftAnchor.constraint(equalTo: emailTF.leftAnchor).isActive = true
        eLine.rightAnchor.constraint(equalTo: emailTF.rightAnchor).isActive = true
        eLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setUpPasswordTF() {
        self.pswd.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        self.pswd.textColor = UIColor.lightGray
        self.pswd.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        self.pswd.clearButtonMode = .whileEditing
        self.pswd.isSecureTextEntry = true
        self.pswd.returnKeyType = .done
        //get NSUserDefaults PASSWORD
        let getUserDefault = UserDefaults.standard
        if let savedPSD = getUserDefault.string(forKey: "PASSWORD") {
            self.pswd.text = savedPSD
        }
        //add left icon
        let imageView = UIImageView()
        imageView.image = UIImage(named: "lock")
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        pswd.leftView = imageView
        pswd.leftViewMode = UITextFieldViewMode.always
        
        pswd.translatesAutoresizingMaskIntoConstraints = false
        pswd.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 10).isActive = true
        pswd.leftAnchor.constraint(equalTo: view.leftAnchor, constant: offset).isActive = true
        pswd.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -offset).isActive = true
        pswd.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    func addPasswordTFBottomLine(){
        self.pswdLine.backgroundColor = UIColor.lightGray
        
        pswdLine.translatesAutoresizingMaskIntoConstraints = false
        pswdLine.topAnchor.constraint(equalTo: pswd.bottomAnchor).isActive = true
        pswdLine.leftAnchor.constraint(equalTo: pswd.leftAnchor).isActive = true
        pswdLine.rightAnchor.constraint(equalTo: pswd.rightAnchor).isActive = true
        pswdLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setUpEmailLogInBtn() {
        self.emailLoginBtn.layer.cornerRadius = 4
        self.emailLoginBtn.backgroundColor = Tools.dancingShoesColor //Indian red
        self.emailLoginBtn.setTitle("LOGIN", for: UIControlState())
        self.emailLoginBtn.titleLabel!.font =  UIFont(name: "ArialRoundedMTBold", size: 18)
        
        emailLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        emailLoginBtn.topAnchor.constraint(equalTo: pswdLine.bottomAnchor, constant: 25).isActive = true
        emailLoginBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: offset).isActive = true
        emailLoginBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -offset).isActive = true
        emailLoginBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        self.emailLoginBtn.addTarget(self, action: #selector(loginWithEmail), for: .touchUpInside)
        
    }
    
    func loginWithEmail() {
        //check text field filled correctly
        if Tools.isEmail(Tools.trim(self.emailTF.text!)) && Tools.trim(self.pswd.text!).characters.count >= 6 {
            //NSUserDefaults
            let saveEandP = UserDefaults.standard
            saveEandP.set(Tools.trim(self.emailTF.text!), forKey: "EMAIL")
            saveEandP.set(Tools.trim(self.pswd.text!), forKey: "PASSWORD")
            
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            SVProgressHUD.show(withStatus: "Logging in...")
            guard let email = self.emailTF.text, let psd = self.pswd.text
                else {return}
            FIRAuth.auth()?.signIn(withEmail: Tools.trim(email), password: Tools.trim(psd), completion: {(user, error) in
                if error != nil {
                    SVProgressHUD.dismiss()
                    let loginErrorAlert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) {(_: UIAlertAction) -> Void in}
                    loginErrorAlert.addAction(action)
                    self.present(loginErrorAlert, animated: true, completion: nil)
                    //print(error?.localizedDescription)
                    return
                }
                SVProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
                
            })
        } else {
            if !Tools.isEmail(Tools.trim(self.emailTF.text!)) {
                Tools.shakingUIView(emailTF)
            } else if (Tools.trim(self.pswd.text!).characters.count < 6) {
                Tools.shakingUIView(pswd)
            }
        }
        
    }
    
    func setUpOrLable() {
        self.orLable.text = "OR"
        self.orLable.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        self.orLable.textColor = UIColor.lightGray
        //set to be at center
        self.orLable.textAlignment = .center
        orLable.translatesAutoresizingMaskIntoConstraints = false
        orLable.topAnchor.constraint(equalTo: forgetPasswordBtn.bottomAnchor, constant: 15).isActive = true
        orLable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        orLable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func setUpForgetPasswordButton() {
        self.forgetPasswordBtn.setTitle("Forget your password?", for: UIControlState())
        self.forgetPasswordBtn.setTitleColor(UIColor.lightGray, for: UIControlState())
        self.forgetPasswordBtn.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 14)
        
        forgetPasswordBtn.translatesAutoresizingMaskIntoConstraints = false
        forgetPasswordBtn.topAnchor.constraint(equalTo: emailLoginBtn.bottomAnchor, constant: 10).isActive = true
        forgetPasswordBtn.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        forgetPasswordBtn.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.forgetPasswordBtn.addTarget(self, action: #selector(popUpResetPasswordAlert), for: .touchUpInside)
    }
    func popUpResetPasswordAlert() {
        var resetEmailTF: UITextField?
        let resetPasswordAlert = UIAlertController(title: "Tell me your Email", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Reset Password", style: .default) {(result: UIAlertAction) -> Void in
            //send email to reset password
            //print(resetEmailTF?.text)
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            SVProgressHUD.show(withStatus: "Please wait...")
            FIRAuth.auth()?.sendPasswordReset(withEmail: (resetEmailTF?.text)!) {error in
                if error != nil {
                    //display error
                    SVProgressHUD.dismiss()
                    //print(error?.localizedDescription)
                    let sendEmailFailed = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let ok1Action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {(_: UIAlertAction) -> Void in                    }
                    sendEmailFailed.addAction(ok1Action)
                    self.present(sendEmailFailed, animated: true, completion: nil)
                    return
                }else {
                    //tell user check email, reset password link was sent
                    SVProgressHUD.dismiss()
                    let sendEmailSuccess = UIAlertController(title: "Check you Inbox", message: "Reset password email was sent to your Email", preferredStyle: UIAlertControllerStyle.alert)
                    let ok2Action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {(_: UIAlertAction) -> Void in                    }
                    sendEmailSuccess.addAction(ok2Action)
                    self.present(sendEmailSuccess, animated: true, completion: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {(_: UIAlertAction) -> Void in}
        resetPasswordAlert.addAction(okAction)
        resetPasswordAlert.addAction(cancelAction)
        resetPasswordAlert.addTextField { (tf) -> Void in
            //textfield customization code
            resetEmailTF = tf
            resetEmailTF!.placeholder = "Enter your Email"
            resetEmailTF?.keyboardType = .emailAddress
        }
        self.present(resetPasswordAlert, animated: true, completion: nil)
        
    }
    
    func setupFacebookSignInBtn() {
        self.fbLoginBtn.layer.cornerRadius = 4
        self.fbLoginBtn.backgroundColor = UIColor(red:59/255, green:89/255, blue:152/255, alpha:1.0) //navy blue
        self.fbLoginBtn.setTitle("Sign In With Facebook", for: UIControlState())
        self.fbLoginBtn.titleLabel!.font =  UIFont(name: "ArialRoundedMTBold", size: 16)
        
        fbLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        fbLoginBtn.topAnchor.constraint(equalTo: orLable.bottomAnchor, constant: 20).isActive = true
        fbLoginBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: offset).isActive = true
        fbLoginBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -offset).isActive = true
        fbLoginBtn.heightAnchor.constraint(equalToConstant: 36).isActive = true
        self.fbLoginBtn.addTarget(self, action: #selector(loginFB), for: .touchUpInside)
        
    }
    
    func setUpRegisterBtn() {
        self.registerBtn.setTitle("REGISTER AN ACCOUNT", for: UIControlState())
        self.registerBtn.setTitleColor(UIColor.lightGray, for: UIControlState())
        self.registerBtn.titleLabel!.font =  UIFont(name: "ArialRoundedMTBold", size: 12)
        
        registerBtn.translatesAutoresizingMaskIntoConstraints = false
        registerBtn.topAnchor.constraint(equalTo: fbLoginBtn.bottomAnchor, constant: 25).isActive = true
        registerBtn.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        registerBtn.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.registerBtn.addTarget(self, action: #selector(goToRegisterPage), for: .touchUpInside)
    }
    
    func disMisSignInVc(){
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default;
    }
    // called when Facebook login button clicked.
    func loginFB() {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.show(withStatus: "Logging in...")
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self){ (result, err) in
            if err != nil {
                SVProgressHUD.dismiss()
                return
            } else if (result?.isCancelled)! {
                SVProgressHUD.dismiss()
            }
            else {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    if error != nil{
                        //report error then return
                        //print(error)
                        SVProgressHUD.dismiss()
                        return}
                    if let uid = user?.uid {
                        //check if this user exists or not
                        //print(uid)
                        let ref = FIRDatabase.database().reference().child("users")
                        ref.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                            if snapshot.hasChild(uid) {
                                //user exists
                                SVProgressHUD.dismiss()
                                self.dismiss(animated: true, completion: nil)
                            } else {
                                //user not exists
                                var values: Dictionary = [String: String]()
                                if let name = user?.displayName {
                                    values["name"] = name
                                }
                                if let email = user?.email {
                                    values["email"] = email
                                }
                                if let url = user?.photoURL?.absoluteString {
                                    values["userAvatarUrl"] = url
                                }
                                Tools.registerUserIntoDatabaseWithUID(uid, values: values)
                                SVProgressHUD.dismiss()
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    } else {
                        //no uid find
                        SVProgressHUD.dismiss()
                    }
                }
            }
        }
    }
    func goToRegisterPage() {
        let registerPage = RegisterWithEmail()
        self.present(registerPage, animated: true, completion: nil)
    }
     
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTF {
            self.pswd.becomeFirstResponder()}
        else {
            self.pswd.resignFirstResponder()}
        return true
    }
    
    func allTextFieldsResignFirstResponder() {
        self.emailTF.resignFirstResponder()
        self.pswd.resignFirstResponder()
    }

}
