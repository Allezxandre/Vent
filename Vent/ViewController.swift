//
//  ViewController.swift
//  Vent
//
//  Created by dodo-mac on 22/05/2015.
//  Copyright (c) 2015 Dorian Rouby. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var compassView: UIImageView!
    @IBOutlet weak var drapeauUIView: DrapeauView!
    
    var locationManager: CLLocationManager!
    var données: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get position
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // Start compass
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.headingFilter = 1
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK Animation Boussole
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading:CLHeading) -> () {
        // Convert Degree to Radian and move the needle
        let newRad: CGFloat =  CGFloat(-newHeading.trueHeading * M_PI / 180.0)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            if let fonctionne = self.données {
                println("Nouvel angle : \(newRad + CGFloat(self.données.windItem.directionRadians))")
                self.drapeauUIView.transform = CGAffineTransformMakeRotation(newRad + CGFloat(self.données.windItem.directionRadians))
            } else {
                println("Nouvel angle : \(newRad)")
                self.drapeauUIView.transform = CGAffineTransformMakeRotation(newRad)

            }
    })
    }
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        données?.longitude = Float(newLocation.coordinate.longitude)
        données?.latitude = Float(newLocation.coordinate.latitude)
        println("Latitude : \(newLocation.coordinate.latitude), longitude : \(newLocation.coordinate.longitude)")
        if ((données?.longitude != Float(newLocation.coordinate.longitude)) && (données?.latitude != Float(newLocation.coordinate.latitude)) ) {
            // Start weather fetch
            Weather.retrieveWeather(latitude: Float(newLocation.coordinate.latitude), longitude: Float(newLocation.coordinate.longitude)) { (resultat) -> Void in
                self.takeWeather(resultat)
            // Stop getting location
            self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func takeWeather(météo: Weather) -> Void {
        données?.latitude = météo.latitude
        données?.longitude = météo.longitude
        données?.windItem = météo.windItem
    }



}

