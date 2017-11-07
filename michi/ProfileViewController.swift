//
//  ProfileViewController.swift
//  michi
//
//  Created by Michel Schoemaker on 6/2/16.
//  Copyright © 2016 Michel Schoemaker. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        profileImage.clipsToBounds = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let weakSelf = self
        //some code here used from https://firebase.google.com/docs/database/ios/retrieve-data#read_data_once
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            weakSelf.userName.text! = snapshot.value!["userName"]!!["userName"] as! String
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    var ref = FIRDatabase.database().reference()
    
    @IBOutlet private weak var userName: UILabel!
    
    var imagePicker: UIImagePickerController!
    
    @IBAction func selectProfileImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        profileImage.image = image
    }
}
