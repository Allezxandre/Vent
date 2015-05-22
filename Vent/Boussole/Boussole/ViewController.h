//
//  ViewController.h
//  Boussole
//
//  Created by dodo-mac on 22/05/2015.
//  Copyright (c) 2015 dodo-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>




@interface ViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    UIImageView* boussole;
    UIImageView* flecheWind;
    float coordinateLongitude;
    float coordinateLatitude;
    UILabel* labelSpeed;

}

@property (nonatomic,retain) CLLocationManager *locationManager;

@end

