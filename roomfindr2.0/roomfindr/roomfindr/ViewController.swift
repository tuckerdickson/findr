/*
 
 ViewController.swift
 roomfindr

 This class controls the logic for the main screen of the application.

 Created on 2/25/23.
 
 */

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {
    private let locationManager = CLLocationManager()   // location manager
    private var alertController: UIAlertController?     // used to alert the user of location problems
    private var previousLocation: CLLocation!           // used when updating location
    @IBOutlet var mapView: MKMapView!                   // connects to map in Main storyboard
    private let regionMeters = 100.0                    // the region that the map covers by default

    
    
    /*
     Description: This function gets called every time this view loads (when opening the app).
     Inputs: None
     Outputs: None
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    /*
     Description: This function gets called every time this view appears (switching to this view from another, for example).
     Inputs: animated - If true, the view was added to the window using an animation.
     Outputs: None
     */
    override func viewDidAppear(_ animated: Bool) {
        // request permission to obtain location from the user
        locationManager.requestWhenInUseAuthorization()
        
        // initialize locationManager attributes
        setupLocationManager()
        
        // make sure we have location authorization
        checkLocationAuthorization()
    }
    
    
    
    /*
     Description: This function initializes CLLocationManager attributes.
     Inputs: None
     Outputs: None
     */
    func setupLocationManager() {
        // set locationManager.delegate to self so that we can use delegate methods below
        locationManager.delegate = self
        
        // set desired accuracy to best
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    
    /*
     Description: This function checks the location authorization of the app and handles the various cases.
     Inputs: None
     Outputs: None
     */
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        
        // in this case, when-in-use authorization has been obtained already
        case .authorizedWhenInUse:
            // show the user's location on the map
            mapView.showsUserLocation = true
            
            // center the user on the map and zoom in
            centerMapOnUser()
            
            // begin updating the user's location
            //locationManager.startUpdatingLocation()
            
            // initialize previousLocation to the users current location
            self.previousLocation = locationManager.location
            
            break
            
        // this case would be executed if always authorization was granted
        // we don't request always authorization, so we ignore this case
        case .authorizedAlways:
            break
            
        // in this case, authorization has been neither granted nor denied
        case .notDetermined:
            // request when in use authorization
            locationManager.requestWhenInUseAuthorization()
            break
            
        // in this case, when-in-use authorization has already been denied
        case .denied:
            // alert the user that these permissions are required
            alertUser(choice: "denied")
            
            // close the app
            exit(0)
            break
            
        // in this case, location authorization has been restricted for some reason (e.g. parental controls)
        case .restricted:
            // let the user know their location is restricted
            alertUser(choice: "restricted")
            
            // close the app
            exit(0)
            break
            
        // this is the default case, not really sure what would trigger this
        @unknown default:
            // alert the user that something weird has happened
            alertUser(choice: "unknown")
            
            // close the app
            exit(0)
            break
        }
    }
    
    
    
    /*
     Description: This function sets the center of the map view and constrains the region visible on the screen.
     Inputs: None
     Outputs: None
     */
    func centerMapOnUser() {
        // if the optional variable locationManager.location contains a value, bind it to location
        if let location = locationManager.location?.coordinate {
            
            // specify the geographic region to present
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            
            // set the region specified above
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    
    /*
     Description: This function sends an alert to the screen for various different scenarios.
     Inputs: choice - This string represents the specific scenario encountred.
     Outputs: None
     */
    func alertUser(choice: String) {
        var title = ""          // title of the alert
        var message = ""        // main message to be displayed
        
        // craft appropriate title and message, depending on circumstances
        if(choice == "ls") {
            title = "Enable Location Services"
            message = "Please enable location services to continue using roomfindr."
        } else if (choice == "denied") {
            title = "Please Authorize Location"
            message = "Please authorize your location to continue using roomfindr."
        } else if(choice == "restricted") {
            title = "Location Restricted"
            message = "Your location is currently restricted. Please make your location available to continue using roomfindr."
        } else if (choice == "unknown") {
            title = "Unknown Error"
            message = "For unknown reasons, your location is not available."
        } else {
            return
        }

        // craft an alert using title and message
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // add an "Okay" button
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        
        // show alert
        self.present(alert, animated: true)
    }
}



// The following functions are delegate functions of CLLocationManager
extension ViewController: CLLocationManagerDelegate {
    /*
     Description: This function gets called every time the users location updates.
     Inputs:    manager - The location manager object that generated the update event.
                locations - An array of CLLocation objects containing the location data.
     Outputs: None
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        // guard against there being no location
//        guard let newLocation = locations.last else { return }
//
//        // delta is the change in distance from the last location to the new location
//        let delta = (newLocation.distance(from: previousLocation))
//
//        //print("Lat: \(newLocation.coordinate.latitude)\tLng: \(newLocation.coordinate.longitude)\tDelta: \(delta)")
//
//        // to reduce noise, don't update the user's location if they jump several meters
//        if (delta >= (newLocation.horizontalAccuracy * 0.5)) {
//            // update the previous location
//            previousLocation = newLocation
//
//            // set location
//            let location = newLocation
    }
    
    
    
    /*
     Description: This function gets called every time the location authorization status changes.
     Inputs:    manager - The location manager object that generated the update event.
                status - The updated location authorization status.
     Outputs: None
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // see what the updated authorization status is
        checkLocationAuthorization()
    }
}
