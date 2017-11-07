//
//  LocatorViewController.swift
//  michi
//
//  Created by Michel Schoemaker on 6/2/16.
//  Copyright © 2016 Michel Schoemaker. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import Firebase

class LocatorViewController: UIViewController, UICollectionViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = FIRAuth.auth()?.currentUser?.uid
        weak var weakSelf = self
        ref.child("users").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            weakSelf!.userNeedsHelpWith = snapshot.value!["needsHelpWith"]!!["needsHelpWith"] as! [String:Bool]
            var i = 0
            for (key,value) in weakSelf!.userNeedsHelpWith {
                if value == true {
                    weakSelf!.createFrame(key, i: &i)
                }
            }
            weakSelf!.scrollView.contentSize = CGSizeMake(weakSelf!.view.frame.size.width*CGFloat(i), weakSelf!.view.frame.size.height)
            weakSelf!.create3DTouchShortcuts(weakSelf!.userNeedsHelpWith)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //some of the code from this function from https://www.veasoftware.com/posts/swipe-navigation-in-swift-xcode-7-ios-9-tutorial
    private func createFrame(key:String, inout i:Int) {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier(key)
        var frame = vc.view.frame
        frame.origin.x = self.view.frame.size.width*CGFloat(i)
        vc.view.frame = frame
        self.addChildViewController(vc)
        self.scrollView.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
        i += 1
    }
    
    private func create3DTouchShortcuts(userNeedsHelpWith:[String:Bool]) {
        var shortcuts = [UIApplicationShortcutItem]()
        shortcuts.append(UIApplicationShortcutItem(type:"Locator", localizedTitle:" Locator", localizedSubtitle: "Dynamic Action", icon: UIApplicationShortcutIcon(type: .Add), userInfo: nil))
        shortcuts.append(UIApplicationShortcutItem(type:"Saved", localizedTitle:"Saved", localizedSubtitle: "Dynamic Action", icon: UIApplicationShortcutIcon(type: .Add), userInfo: nil))
        UIApplication.sharedApplication().shortcutItems = shortcuts
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var userNeedsHelpWith = [String:Bool]()
    
    private var ref = FIRDatabase.database().reference()
    
    private let userID = FIRAuth.auth()?.currentUser?.uid

}
