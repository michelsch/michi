//
//  LanguagePhrasesViewController.swift
//  michi
//
//  Created by Michel Schoemaker on 6/4/16.
//  Copyright © 2016 Michel Schoemaker. All rights reserved.
//

import UIKit
import CoreData
import Social

class LanguagePhrasesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (key, value) in (phrases as! [String:String]) {
             phrasesLabel.text!.appendContentsOf(key + "  -  "
                + value + "\n")
        }
        phrasesLabel.numberOfLines = 0
        titleLabel.text! =  location!
    }
    
    var phrases: AnyObject?
    var location: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phrasesLabel: UILabel!
    
    @IBAction func savePhrases(sender: AnyObject) {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let phraseEntity = NSEntityDescription.entityForName("Phrase", inManagedObjectContext: context)
        let locationEntity = NSEntityDescription.entityForName("Location", inManagedObjectContext: context)
        let location = Location(entity:locationEntity!, insertIntoManagedObjectContext: context)
        location.name = titleLabel.text!
        context.insertObject(location)
        for (key, value) in (phrases as! [String:String]) {
            let phrase = Phrase(entity:phraseEntity!, insertIntoManagedObjectContext:context)
            phrase.phrase = key + "   -   " + value
            context.insertObject( phrase)
        }
        do {
            try context.save()
        } catch {
            print("Could not save")
        }
    }
    
    //some of this function transcribed from https://github.com/lotpb/iosSQLswift/blob/master/mySQLswift/SocialController.swift
    @IBAction func sharePhrases(sender: AnyObject) {
        let actions = UIAlertController(title: "", message: "Share your Note", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let twitterShare = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default) { (action) -> Void in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                let twitterVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterVC.setInitialText("Useful phrases at " + self.titleLabel.text! + "!\n" + "fakelink.com")
                self.presentViewController(twitterVC, animated: true, completion: nil)
            }
            else {
                self.alertNotLoggedIn("Twitter")
            }
        }
        actions.addAction(twitterShare)
        let facebookShare = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.Default) { (action) -> Void in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let facebookVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                self.presentViewController(facebookVC, animated: true, completion: nil)
            }
            else {
                self.alertNotLoggedIn("Facebook")
            }
        }
        actions.addAction(facebookShare)
        presentViewController(actions, animated: true, completion: nil)
    }
    
    func alertNotLoggedIn(platform:String) {
        let alertController = UIAlertController(title: "Error", message: "Not logged into " +  platform, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
