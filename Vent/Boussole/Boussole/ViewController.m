//
//  ViewController.m
//  Boussole
//
//  Created by dodo-mac on 22/05/2015.
//  Copyright (c) 2015 dodo-mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


@implementation ViewController
@synthesize locationManager;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    locationManager=[[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.headingFilter = 1;
    locationManager.delegate = self;
    [locationManager startUpdatingHeading];
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    

    
    boussole = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"boussole"]];
    boussole.center = CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.5);
    [self.view addSubview:boussole];
    
    flecheWind = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fleche"]];
    flecheWind.center = CGPointMake(boussole.frame.size.width*0.5, boussole.frame.size.height*0.5);
    flecheWind.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.5, 0.5), M_PI/3);
    [boussole addSubview:flecheWind];
    
    labelSpeed = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.25, self.view.frame.size.height-200, self.view.frame.size.width*0.75, 200)];
    labelSpeed.numberOfLines = 4;
    [self.view addSubview:labelSpeed];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    // Convert Degree to Radian and move the needle

    float newRad =  -newHeading.trueHeading * M_PI / 180.0f;
    [UIView animateWithDuration:0.5 animations:^{
        boussole.transform = CGAffineTransformMakeRotation(newRad);
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    coordinateLongitude = newLocation.coordinate.longitude;
    coordinateLatitude = newLocation.coordinate.latitude;
    NSLog(@"Location: Longitude %.8f Latitude %.8f", coordinateLongitude,coordinateLatitude);

    
    // Construction de l'url à récupérer
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f",coordinateLatitude,coordinateLongitude]]];
   
    // execution de la requête et récupération du JSON via un objet NSData
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // On récupère le JSON en NSString depuis la réponse
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSError *jsonError;
    NSDictionary* dico = [NSJSONSerialization JSONObjectWithData:[json_string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
    
    if (dico)
    {
        NSLog(@"%@",[dico objectForKey:@"wind"]);
        
        float deg = [[[dico objectForKey:@"wind"]objectForKey:@"deg"]floatValue];
        [UIView animateWithDuration:0.5 animations:^{
            flecheWind.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.4, 0.4), deg*M_PI/180.0f);
        }];
        labelSpeed.text = [NSString stringWithFormat:@"Speed: %.2f Km/h\nDegres: %.2f°\nTemperature: %.1f\nhumidité: %d%%",[[[dico objectForKey:@"wind"]objectForKey:@"speed"]floatValue],deg,[[[dico objectForKey:@"main"]objectForKey:@"temp"]floatValue]-275.16,[[[dico objectForKey:@"main"]objectForKey:@"humidity"]intValue]];
    }
    

}

@end
