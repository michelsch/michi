//
//  SavedPhrasesViewController.swift
//  
//
//  Created by Michel Schoemaker on 6/4/16.
//
//

import UIKit
import CoreData
import Social

class SavedPhrasesViewController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated:Bool) {
        super.viewDidAppear(animated)
        fetchPhrases()
        tableView.reloadData()
    }
    
    var locations = [Location]()
    
    var phrases = [Phrase]()
    
    func fetchPhrases() {
        phrases.removeAll()
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Phrase")
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            self.phrases = results as! [Phrase]
        } catch let error as NSError {
            print(error)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phrases.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("phraseCell", forIndexPath: indexPath) as! SavedPhraseCell
        let phrase = phrases[indexPath.row]
        cell.phraseLabel.text! = phrase.phrase!
        return cell
    }
    
    
    
}
