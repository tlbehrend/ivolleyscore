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
    var passwordReset = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

        
//        if DataService.ds.REF_BASE.authData != nil {
//            // already logged in, so let's hide email/pwd fields for login
//            self.showLoggedInOptions()
//            
//        }
        
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
            
//            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
//                
//                if error != nil {
//                    
//                    switch error.code {
//                    case STATUS_INVALID_EMAIL:
//                        self.spinner.stopAnimating()
//                        self.showErrorAlert("Invalid Email", msg: "Please enter a valid email address")
//                    case STATUS_INVALID_PWD:
//                        self.spinner.stopAnimating()
//                        self.showResetPasswordAlert("Invalid Password", msg: "Password in not correct", email: email)
//                        //self.showErrorAlert("Invalid Password", msg: "Password is not correct")
//                    case STATUS_NETWORK_ERROR:
//                        self.spinner.stopAnimating()
//                        self.showErrorAlert("Network Error", msg: "Sorry, there is no internet connection available.")
//                    case STATUS_ACCOUNT_NONEXIST:
//                        // this user does not have account, so we will create one now
//                        
//                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { err, result in
//                            
//                            if err != nil {
//                                self.spinner.stopAnimating()
//                                self.showErrorAlert("Unable to Create Account", msg: "Error creating account.  Error code \(err.code)")
//                            }
//                            else{
//                                
//                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
//                                
//                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { err, authData in
//                                    
//                                    let user = ["email": email]
//                                    DataService.ds.createFirebaseUser(authData.uid, user: user)
//                                    
//                                })
//                                
//                                //self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
//                                self.spinner.stopAnimating()
//                                self.showLoggedInOptions()
//                            }
//                        })
//                    default:
////                        print(error)
//                        self.showErrorAlert("Error Logging In", msg: "Error code \(error.code)")
//                    }
//                    
//                }
//                // error is nil, meaning log in is successful
//                else {
//                    
//                    self.spinner.stopAnimating()
//                    
//                    if self.passwordReset {
//                        self.changePasswordAlert(email, oldPW: pwd)
//                    }
//                    self.showLoggedInOptions()
//                }
//            })
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
            
//            DataService.ds.REF_BASE.resetPasswordForUser(email, withCompletionBlock: {
//            
//                error in
//                
//                if error != nil {
////                    print("error sending password reset email")
//                    
//                } else {
////                    print("password reset email sent")
//                    self.passwordReset = true
//                    self.showErrorAlert("Password Reset", msg: "Check your email for your temporary password")
//                }
//            })
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(resetAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
            
    }
    
    func changePasswordAlert(email: String, oldPW: String) {
        
        let alert = UIAlertController(title: "Change Password", message: "", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({
            (textField : UITextField!) -> Void in
            
            textField.placeholder = "Enter New Password"
            textField.secureTextEntry = true
        })
        
        alert.addTextFieldWithConfigurationHandler({
            (textField : UITextField!) -> Void in
            
            textField.placeholder = "Re-Enter New Password"
            textField.secureTextEntry = true
        })
        
        let changePWAction = UIAlertAction(title: "Change PW", style: .Default, handler: {
        
            changePWAction in
            
            let pw1TextField = alert.textFields![0] as UITextField
            let pw2TextField = alert.textFields![1] as UITextField
            
            if let pw1 = pw1TextField.text where pw1 != "", let pw2 = pw2TextField.text where pw2 != "" {
                
                if pw1 == pw2 {
//                    print("passwords match - will reset for user: \(email)")
//                    print("oldpw: \(oldPW)")
//                    print("newpw: \(pw1)")
                    
                    self.changePassword(email, oldPW: oldPW, newPW: pw1)
                    
                } else {
//                    print("passwords do not match")
                }
                
            }
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(changePWAction)
        alert.addAction(cancel)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func changePassword(user: String, oldPW: String, newPW: String) {
        
        print("change pwd called")
        
//        DataService.ds.REF_BASE.changePasswordForUser(user, fromOld: oldPW, toNew: newPW, withCompletionBlock: {
//        
//            error in
//            
//            if error != nil {
////                print(error)
//            }
//            else {
//                self.passwordReset = false
////                print("successful password change")
//            }
//        })
    }
    
    func showLoggedInOptions() {
        loginView.hidden = true
        scoreView.hidden = false
        scoreGameBtn.hidden = false
        logOutBtn.hidden = false
    }
    
    @IBAction func logout(sender: AnyObject) {
//        DataService.ds.REF_BASE.unauth()
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

