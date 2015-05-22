//
//  Weather.swift
//  HMWK 8
//
//  Created by Marcia Elyseu on 4/22/15.
//  Copyright (c) 2015 Marcia Elyseu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Weather {
    var latitude: Float
    var longitude: Float
    var windItem: Wind
    
    init(latitude: Float, longitude: Float, windObject: Wind){
        self.latitude = latitude
        self.longitude = longitude
        self.windItem = windObject
    }
    

    class func retrieveWeather(latitude: Float, longitude: Float, completionHandler : ((Weather) -> Void)) {
    Alamofire.request(.GET, "api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)")
        .response { (request, response, data, error) -> Void in
            let json = JSON(data: data as! NSData)
            
            println(json["wind"])
            
            var weatherItems = Wind(vitesse: 50, direction: 30)
            
            println(json)
            /*
            for (index: String, item: JSON) in json["list"] {
                var weatherItem = WeatherItem(date: item["dt_txt"].stringValue, temp: item["main"]["temp"].doubleValue, desc: item["weather"][0]["description"].stringValue, iconId: item["weather"][0]["icon"].stringValue)
                weatherItems.append(weatherItem)
            }*/
            
            let weather = Weather(latitude: latitude, longitude: longitude, windObject: weatherItems)
            completionHandler(weather)
        }
    }
}