//
//  ViewController.swift
//  plant place
//
//  Created by Alan on 22/09/2016.
//  Copyright © 2016 Alan Glasby. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    let regionRadius:CLLocationDistance = 500
    
    
    let reading = AppleStores(title: "Reading", coordinate: CLLocationCoordinate2D(latitude: 51.453655, longitude: -0.971328), info: "The Oracle")
    let basingstoke = AppleStores(title: "Basingstoke", coordinate: CLLocationCoordinate2D(latitude: 51.265572, longitude: -1.085481), info: "Festival Place")
    let southampton = AppleStores(title: "Southampton", coordinate: CLLocationCoordinate2D(latitude: 50.903591, longitude: -1.407199), info: "West Quay")
    
    @IBOutlet weak var myMapMapView: MKMapView!

    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        myMapMapView.setRegion(coordinateRegion, animated: true)
        
    }
 
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Store"
        
        if annotation is AppleStores {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                let btn = UIButton(type: .detailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                annotationView!.annotation = annotation
            }
            return annotationView
        }
        return nil
    }

    @objc(mapView:annotationView:calloutAccessoryControlTapped:) func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let store = view.annotation as! AppleStores
        let placeName = store.title
        let placeInfo = store.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        myMapMapView.addAnnotations([reading, basingstoke, southampton])
        
        let initialLocation = CLLocation(latitude: reading.coordinate.latitude, longitude: reading.coordinate.longitude)
        
        centerMapOnLocation(location: initialLocation)
        
    }
    
    // MARK: - location manager to authorize user location for Maps app
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            myMapMapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.myMapMapView.setRegion(region, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    
    @IBAction func showMeSwitch(_ sender: AnyObject) {
        if myMapMapView.userTrackingMode != .follow {
        myMapMapView.userTrackingMode = .follow
        } else {
            myMapMapView.userTrackingMode = .none
        }
    }
    

    @IBAction func location1Btn(_ sender: AnyObject) {
        let setLocation = CLLocation(latitude: reading.coordinate.latitude, longitude: reading.coordinate.longitude)
        
        centerMapOnLocation(location: setLocation)
    }
    

    @IBAction func location2Btn(_ sender: AnyObject) {
        let setLocation = CLLocation(latitude: basingstoke.coordinate.latitude, longitude: basingstoke.coordinate.longitude)
        
        centerMapOnLocation(location: setLocation)
    }
    

    @IBAction func location3Btn(_ sender: AnyObject) {
        let setLocation = CLLocation(latitude: southampton.coordinate.latitude, longitude: southampton.coordinate.longitude)
        
        centerMapOnLocation(location: setLocation)
    }
}

