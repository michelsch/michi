//
//  SettingsViewController.swift
//  michi
//
//  Created by Michel Schoemaker on 6/5/16.
//  Copyright © 2016 Michel Schoemaker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkSwitches()
    }

    @IBOutlet weak var germanSwitch: UISwitch!
    
    @IBOutlet weak var chineseSwitch: UISwitch!
    
    @IBOutlet weak var frenchSwitch: UISwitch!
    
    private var ref = FIRDatabase.database().reference()
    
    private let userID = FIRAuth.auth()?.currentUser?.uid
    
    @IBAction func toggleSwitch(sender: AnyObject) {
        weak var weakSelf = self
        ref.child("users").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            var status = snapshot.value!["needsHelpWith"]!!["needsHelpWith"] as! [String:Bool]
            let _switch = sender as! UISwitch
                switch _switch {
                    case weakSelf!.germanSwitch:
                        weakSelf!.ref.child("users").child(weakSelf!.userID!).child("needsHelpWith/needsHelpWith/German").setValue(!status["German"]!)
                    case weakSelf!.chineseSwitch:
                        weakSelf!.ref.child("users").child(weakSelf!.userID!).child("needsHelpWith/needsHelpWith/Chinese").setValue(!status["Chinese"]!)
                    case weakSelf!.frenchSwitch:
                        weakSelf!.ref.child("users").child(weakSelf!.userID!).child("needsHelpWith/needsHelpWith/French").setValue(!status["French"]!)
                    default:break
                }
        })
    }
    
    func checkSwitches() {
        weak var weakSelf = self
        ref.child("users").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let status = snapshot.value!["needsHelpWith"]!!["needsHelpWith"] as! [String:Bool]
            for (key, value) in status {
                switch key {
                    case "German":
                        weakSelf!.germanSwitch.setOn(value, animated: false)
                    case "Chinese":
                        weakSelf!.chineseSwitch.setOn(value, animated: false)
                    case "French":
                        weakSelf!.frenchSwitch.setOn(value, animated: false)
                    default:break
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
}
