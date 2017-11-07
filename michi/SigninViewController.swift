//
//  SigninViewController.swift
//  michi
//
//  Created by Michel Schoemaker on 5/24/16.
//  Copyright © 2016 Michel Schoemaker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SigninViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var signinButton: UIButton!
    @IBOutlet private weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = FIRAuth.auth()?.currentUser {
            // User is signed in.
            performSegueWithIdentifier("toTabView", sender: nil)
        }
        activityIndicator.hidden = true
        emailField.delegate = self;
        passwordField.delegate = self;
    }
    
    //atempts to sign a user in, segues to next view if successful, otherwise display error message
    @IBAction private func attemptSignin(sender: AnyObject) {
        self.errorMessage.hidden = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        signinButton.hidden = true
        if let email = emailField.text {
            if let password = passwordField.text {
                //use Firebase to authenticate
                FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                    self.activityIndicator.stopAnimating()
                    if error != nil {
                        self.activityIndicator.hidden = true
                        self.signinButton.hidden = false
                        self.errorMessage.hidden = false
                        self.textFieldShouldReturn(self.passwordField)
                    } else {
                        //segue to main view
                        self.performSegueWithIdentifier("toTabView", sender: nil)
                    }
                }
            }
        }
    }
    
    //function from http://stackoverflow.com/questions/24180954/how-to-hide-keyboard-in-swift-on-pressing-return-key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
    }
    
}
