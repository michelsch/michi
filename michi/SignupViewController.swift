//
//  SignupViewController.swift
//  michi
//
//  Created by Michel Schoemaker on 5/25/16.
//  Copyright © 2016 Michel Schoemaker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignupViewController: UIViewController, UITextFieldDelegate  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        germanToggle.backgroundColor = UIColor.whiteColor()
        chineseToggle.backgroundColor = UIColor.whiteColor()
        frenchToggle.backgroundColor = UIColor.whiteColor()
        activityIndicator.hidden = true
        nameLabel.delegate = self
        emailLabel.delegate = self
        passwordLabel.delegate = self
    }
    
    private var ref = FIRDatabase.database().reference()
    
    var userNeedsHelpWith = ["German":false, "Chinese":false, "French":false]
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var germanToggle: UIButton!
    @IBOutlet weak var chineseToggle: UIButton!
    @IBOutlet weak var frenchToggle: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction private func toggleNeedsHelpWith(sender: AnyObject) {
        let button = sender as! UIButton
        if button.backgroundColor != UIColor.whiteColor() {
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor(red:0.13, green:0.58, blue:0.55, alpha:1.0), forState: .Normal)
        } else {
            button.backgroundColor = UIColor(red:0.13, green:0.58, blue:0.55, alpha:1.0)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        toggle(sender, dict: &userNeedsHelpWith)
    }
    
    private func toggle (sender:AnyObject, inout dict:[String:Bool]) {
        if let button = sender as? UIButton {
            let language = (button.titleLabel?.text)!
            dict[language] = !dict[language]!
        }
    }
    
    func noLanguagesSelected() -> Bool {
        if userNeedsHelpWith.values.contains(true) {
            return false
        }
        return true
    }
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet private weak var nameLabel: UITextField!
    
    @IBOutlet private weak var emailLabel: UITextField!
    
    @IBOutlet private weak var passwordLabel: UITextField!
    
    @IBAction private func attemptSignup(sender: AnyObject) {
        if noLanguagesSelected() {
            errorMessage.text! = "Select at least one language"
            errorMessage.hidden = false
            return
        }
        errorMessage.hidden = true
        signupButton.hidden = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        if let email = emailLabel.text {
            if let password = passwordLabel.text {
                FIRAuth.auth()!.createUserWithEmail(email, password:password) {(user,error) in
                    if error != nil {
                        print(error)
                        self.errorMessage.hidden = false
                    }
                    else {
                        var userName:String?
                        if let name = self.nameLabel.text {
                            userName = name
                        } else {
                            userName = " "
                        }
                        self.ref.child("users").child(user!.uid).child("userName").setValue(["userName": userName!])
                        self.ref.child("users").child(user!.uid).child("needsHelpWith").setValue(["needsHelpWith":self.userNeedsHelpWith])
                        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                            if error != nil {
                                self.errorMessage.text! = "Error signing up"
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.hidden = true
                                self.errorMessage.hidden = false
                                self.signupButton.hidden = false
                            } else {
                                self.performSegueWithIdentifier("toTabView", sender: nil)
                            }
                        }
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

}
