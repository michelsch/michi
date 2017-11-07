
//
//  LanguageLocatorViewController.swift
//  michi
//
//  Created by Michel Schoemaker on 6/4/16.
//  Copyright © 2016 Michel Schoemaker. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import FirebaseDatabase

class LanguageLocatorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient()
        collectionView.delegate = self
        collectionView.dataSource = self
        mapView.delegate = self
    }
    
    
    override func viewDidAppear(animated:Bool) {
        super.viewDidAppear(animated)
        locationStatus()
        getNearbyPlaces()
    }
    
    var ref = FIRDatabase.database().reference()
    
    let locationManager = CLLocationManager()
    
    let mapRadius: CLLocationDistance = 1000
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var placesClient: GMSPlacesClient?
    
    var places = [String]()
    
    var cells = [String:AnyObject]()
    
    var cellKeys = [String]()
    
    var cellValues = [AnyObject]()
    
    func getNearbyPlaces() {
        cellKeys.removeAll(keepCapacity: false)
        cellValues.removeAll(keepCapacity: false)
        //most of this code snippet from https://developers.google.com/places/ios-api/place-details#place-details
        weak var weakSelf = self
        placesClient?.currentPlaceWithCallback({ (placeLikelihoods, error) -> Void in
            guard error == nil else {
                print("Current Place error: \(error!.localizedDescription)")
                return
            }
            if let placeLikelihoods = placeLikelihoods {
                for likelihood in placeLikelihoods.likelihoods {
                    let place = likelihood.place
                    if !weakSelf!.places.contains(place.types[0]) {
                        weakSelf!.places.append(place.types[0])
                    }
                    print(self.places)
                }
            }
            weakSelf!.ref.child(weakSelf!.restorationIdentifier!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                weakSelf!.cells = snapshot.value as! [String:AnyObject]
                for (key,value) in weakSelf!.cells {
                    if weakSelf!.places.contains(key) {
                        weakSelf!.cellKeys.append(key)
                        weakSelf!.cellValues.append(value)
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    weakSelf!.collectionView.reloadData()
                })
            }) { (error) in
                print(error.localizedDescription)
            }
        })
    }
    
    func locationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            mapView.showsUserLocation = true
        }
        else {
            locationManager.requestAlwaysAuthorization()
            mapView.showsUserLocation = true
        }
    }
    
    func centerMap(location:CLLocation) {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, mapRadius, mapRadius)
        mapView.setRegion(region, animated:true)
        
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let location = userLocation.location
        {
            centerMap(location)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellKeys.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LocatorCell", forIndexPath: indexPath) as! LocatorCell
        cell.textLabel.text = cellKeys[indexPath.row].stringByReplacingOccurrencesOfString("_", withString: " ").capitalizedString
        cell.image.image = UIImage(named:"location.png")
        cell.phrases = cellValues[indexPath.row]
        cell.locationTitle = cell.textLabel.text! + " (" + self.restorationIdentifier! + ")"
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPhrases" {
            let destination = segue.destinationViewController as! LanguagePhrasesViewController
            destination.phrases = (sender as! LocatorCell).phrases
            destination.location = (sender as! LocatorCell).locationTitle
        }
    }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
    }
}
