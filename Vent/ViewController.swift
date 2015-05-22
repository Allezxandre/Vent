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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading:CLHeading) -> () {
    // Convert Degree to Radian and move the needle
    // var oldRad =  -manager.heading.trueHeading * M_PI / 180.0
        let newRad: CGFloat =  CGFloat(-newHeading.trueHeading * M_PI / 180.0)
/*    var theAnimation: CABasicAnimation
    theAnimation=CABasicAnimation(keyPath: "transform.rotation")
    theAnimation.fromValue = oldRad
    theAnimation.toValue=newRad
    theAnimation.duration = 0.5
    compassImage.layer.addAnimation
        //forKey:@"animateMyRotation"];
    */
    UIView.animateWithDuration(0.5, animations: { () -> Void in
        println("Salut")
        self.compassView.transform = CGAffineTransformMakeRotation(newRad)
    })
        /*
    compassImage.transform = CGAffineTransformMakeRotation(newRad);
    NSLog(@"%f (%f) => %f (%f)", manager.heading.trueHeading, oldRad, newHeading.trueHeading, newRad);
*/
    }



}

