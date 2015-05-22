//
//  ViewController.swift
//  Vent
//
//  Created by dodo-mac on 22/05/2015.
//  Copyright (c) 2015 dodo-mac. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var compassView: UIImageView!
    var locationManager: CLLocationManager!
    var données: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Start weather fetch
        Weather.retrieveWeather(48, longitude: 4) { (resultat) -> Void in
            self.takeWeather(resultat)
        }
        // Start compass
        locationManager = CLLocationManager()
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
        println("Salut")
        self.compassView.transform = CGAffineTransformMakeRotation(newRad)
    })
    }
    
    func takeWeather(météo: Weather) -> Void {
        données?.latitude = météo.latitude
        données?.longitude = météo.longitude
        données?.windItem = météo.windItem
    }



}

