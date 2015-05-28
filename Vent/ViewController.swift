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
    
    @IBOutlet weak var drapeauUIView: DrapeauView!
    @IBOutlet weak var textField: UITextField!
    
    var locationManager: CLLocationManager!
    var données: Weather!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // Start compass
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.headingFilter = 1
        locationManager.distanceFilter = 100 //mètres
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    override func viewDidDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Location delegate
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading:CLHeading) -> () {
        // Convert Degree to Radian and move the needle
        let newRad: CGFloat =  CGFloat(-newHeading.trueHeading * M_PI / 180.0)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            if let fonctionne = self.données {
                self.drapeauUIView.transform = CGAffineTransformMakeRotation(newRad + CGFloat(self.données.windItem.directionRadians + M_PI))
            } else {
                println("Attention ! Les données ne sont pas encore initialisées")
                self.drapeauUIView.transform = CGAffineTransformMakeRotation(newRad)
            }
    })
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        NSLog("There was an error retrieving location:\n\(error)")
        if !CLLocationManager.headingAvailable() {
            println("\nTu utilises le simulateur, et tu as surement oublié d'activer la localisation...\n(Bolosse)\n\n")
        }
    }
    
    func locationManagerShouldDisplayHeadingCalibration(manager: CLLocationManager!) -> Bool {
        return true
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        // on prend la dernière localisation
        let newLocation = locations.last as! CLLocation
        println("Latitude : \(newLocation.coordinate.latitude), longitude : \(newLocation.coordinate.longitude)")
        // Start weather fetch
        Weather.retrieveWeather(latitude: Float(newLocation.coordinate.latitude), longitude: Float(newLocation.coordinate.longitude)) { (resultat) -> Void in
            self.takeWeather(resultat)
        }
    }
    
    func takeWeather(météo: Weather) -> Void {
        données = Weather(latitude: météo.latitude, longitude: météo.longitude, windObject: météo.windItem)
        if !CLLocationManager.headingAvailable() {
            println("Attention ! Cet iPhone (?) n'a pas les informations sur l'orientation.\nEst-ce qu'il a une boussole au moins ?")
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.drapeauUIView.transform = CGAffineTransformMakeRotation(CGFloat(self.données.windItem.directionRadians + M_PI))
            })
        }
        
        // Afficher le texte
        let fmt = NSNumberFormatter()
        fmt.maximumFractionDigits = 4
        fmt.minimumFractionDigits = 2
        let textFormatté = fmt.stringFromNumber(données!.windItem.speed)!
        textField.text = "\(textFormatté) m/s"
        textField.sizeToFit()
        
    }



}

