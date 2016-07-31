//
//  LoginViewController.swift
//  ivolleyscore
//
//  Created by Terry Behrend on 2/7/16.
//  Copyright © 2016 jbapps. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var scoreView: UIView!
    
    @IBOutlet weak var scoreGameBtn: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    
    @IBOutlet weak var watchGameView: UIView!
    @IBOutlet weak var watchGameViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var watchGameViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var viewMoved = false
    //var passwordReset = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                print("signed in")
                self.showLoggedInOptions()
            } else {
                // No user is signed in.
                print("not signed in")
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            let bottomOfLoginView = loginView.frame.origin.y + loginView.frame.height
            
            let keyboardCoversTextView = bottomOfLoginView > self.view.frame.height - keyboardSize.height
            
            if keyboardCoversTextView && !viewMoved {
               
                self.watchGameViewHeightConstraint.constant = 60
                self.watchGameViewTopConstraint.constant = 8
                self.loginViewTopConstraint.constant = 8
                
                UIView.animateWithDuration(0.5) {
                    self.view.layoutIfNeeded()
                }
                
                viewMoved = true
                
            }
                

            //self.view.frame.origin.y -= keyboardSize.height
            //print("Keyboard height: \(keyboardSize.height)")
            //print("Screen height: \(self.view.frame.height)")
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if viewMoved {
            self.watchGameViewHeightConstraint.constant = 100
            self.watchGameViewTopConstraint.constant = 54
            self.loginViewTopConstraint.constant = 49
            
            UIView.animateWithDuration(0.5) {
                self.view.layoutIfNeeded()
            }
            
            viewMoved = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    

    @IBAction func login(sender: AnyObject) {
        
        if let email = emailTextField.text where email != "", let pwd = passwordTextField.text where pwd != "" {
            self.loginView.bringSubviewToFront(spinner)
            spinner.startAnimating()
            
            FIRAuth.auth()?.signInWithEmail(email, password: pwd) { (user, error) in
                
                if let error = error {
                    print("invalid email")
                    print(error.code)
                    print(error.debugDescription)
                    switch error.code {
                    case FB_AUTH_INVALID_EMAIL:
                        self.spinner.stopAnimating()
                        self.showErrorAlert("Invalid Email", msg: "Please enter a valid email address")
                    case FB_AUTH_INVALID_PWD:
                        self.spinner.stopAnimating()
                        self.showResetPasswordAlert("Invalid Password", msg: "Password in not correct", email: email)
                    case FB_AUTH_NETWORK_ERROR:
                        self.spinner.stopAnimating()
                        self.showErrorAlert("Network Error", msg: "Sorry, there is no internet connection available")
                    case FB_AUTH_USER_NOT_FOUND:
                        // this user does not have account, so we will create one now
                        // creating the account also signs in the user
                        
                        FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (user, error) in
                            
                            if let createUserError = error {
                                
                                self.spinner.stopAnimating()
                                
                                switch createUserError.code {
                                case FB_AUTH_INVALID_EMAIL:
                                    self.showErrorAlert("Invalid Email", msg: "Please enter a valid email address")
                                case FB_AUTH_PWD_TOO_SHORT:
                                    self.showErrorAlert("Weak Password", msg: "The password must be at least 6 characters long")
                                default:
                                    //print(createUserError)
                                    self.showErrorAlert("Error Creating Account", msg: "Error code \(createUserError.code)")
                                }
                            }
                            else{
                                // successfully created new account and logged in user
                                
                                //print(user!.uid)
                                if let user = user {
                                    NSUserDefaults.standardUserDefaults().setValue(user.uid, forKey: KEY_UID)
                                    self.spinner.stopAnimating()
                                    self.showLoggedInOptions()
                                }
                            }
                        })
                    default:
                        print(error)
                        self.showErrorAlert("Error Logging In", msg: "Error code \(error.code)")
                    }
                }
                else {
                    print("No error, so logged in successfully")
                    self.spinner.stopAnimating()
                    
//                    if self.passwordReset {
//                        self.changePasswordAlert(email, oldPW: pwd)
//                    }
                    self.showLoggedInOptions()
                }
                
            }
            
        }
        else {
            showErrorAlert("Email and Password Required", msg: "You must enter both email and password")
        }
        
    }
    
    func showErrorAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showResetPasswordAlert(title: String, msg: String, email: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let resetAction = UIAlertAction(title: "Reset PW", style: .Default, handler: {
            
            resetAction in
            
            FIRAuth.auth()?.sendPasswordResetWithEmail(email) { error in
                if error != nil {
                    // An error happened.
                    self.showErrorAlert("Error", msg: "Sorry, there was an error emailing you a new password")
                } else {
                    // Password reset email sent.
                    print("password reset email sent")
                    // don't need the check for passwordReset because can directly reset in web
                    // rather than old version of FB which sent random password, so this was to update
                    // to something that could be remembered
                    //self.passwordReset = true
                    self.showErrorAlert("Password Reset", msg: "Check your email for your temporary password")
                }
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(resetAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
            
    }
    
    // new Firebase let's user change directly to a password they can remember, so don't need this
    
//    func changePasswordAlert(email: String, oldPW: String) {
//        
//        let alert = UIAlertController(title: "Change Password", message: "", preferredStyle: .Alert)
//        
//        alert.addTextFieldWithConfigurationHandler({
//            (textField : UITextField!) -> Void in
//            
//            textField.placeholder = "Enter New Password"
//            textField.secureTextEntry = true
//        })
//        
//        alert.addTextFieldWithConfigurationHandler({
//            (textField : UITextField!) -> Void in
//            
//            textField.placeholder = "Re-Enter New Password"
//            textField.secureTextEntry = true
//        })
//        
//        let changePWAction = UIAlertAction(title: "Change PW", style: .Default, handler: {
//        
//            changePWAction in
//            
//            let pw1TextField = alert.textFields![0] as UITextField
//            let pw2TextField = alert.textFields![1] as UITextField
//            
//            if let pw1 = pw1TextField.text where pw1 != "", let pw2 = pw2TextField.text where pw2 != "" {
//                
//                if pw1 == pw2 {
////                    print("passwords match - will reset for user: \(email)")
////                    print("oldpw: \(oldPW)")
////                    print("newpw: \(pw1)")
//                    
//                    self.changePassword(email, oldPW: oldPW, newPW: pw1)
//                    
//                } else {
////                    print("passwords do not match")
//                }
//                
//            }
//            
//        })
//        
//        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        
//        alert.addAction(changePWAction)
//        alert.addAction(cancel)
//        presentViewController(alert, animated: true, completion: nil)
//    }
    
//    func changePassword(user: String, oldPW: String, newPW: String) {
//        
//        print("change pwd called")
//        
//        
//        let user = FIRAuth.auth()?.currentUser
//        //let newPassword = getRandomSecurePassword()
//        
//        user?.updatePassword(newPW) { error in
//            if let error = error {
//                // An error happened.
//            } else {
//                // Password updated.
//            }
//        }
//    
//    }
    
    func showLoggedInOptions() {
        loginView.hidden = true
        scoreView.hidden = false
        scoreGameBtn.hidden = false
        logOutBtn.hidden = false
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        try! FIRAuth.auth()!.signOut()
        
        passwordTextField.text = ""
        
        loginView.hidden = false
        scoreView.hidden = true
        scoreGameBtn.hidden = true
        logOutBtn.hidden = true
        
    }
    
    @IBAction func showScoreboard() {
        self.performSegueWithIdentifier(SEGUE_SCOREBOARD, sender: nil)
    }
    
    @IBAction func showScoringTool() {
        self.performSegueWithIdentifier(SEGUE_ENTER_TEAMS, sender: nil)
    }
    
    @IBAction func showMatchSearch() {
        self.performSegueWithIdentifier(SEGUE_MATCH_SEARCH, sender: nil)
    }

}

