//
//  Weather.swift
//  Vent
//
//  Created by Alexandre Jouandin on 22/04/15.
//  Copyright (c) 2015 Alexandre Jouandin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Units: Int {
    case metric = 1
    case imperial
    func stringify() -> String {
        switch self {
            case .metric:
                return "metric"
            case .imperial:
                return "imperial"
        }
    }
}

class Weather {
    var latitude: Float
    var longitude: Float
    var windItem: Wind
    
    init(latitude: Float, longitude: Float, windObject: Wind){
        self.latitude = latitude
        self.longitude = longitude
        self.windItem = windObject
    }
    

    class func retrieveWeather(#latitude: Float, longitude: Float, units: Units = .metric, completionHandler : ((Weather) -> Void)) {
        println("Requesting: http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)")
    Alamofire.request(.GET, "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=\(units.stringify())&language=fr")
        .responseJSON { (request, response, jsonData, error) -> Void in
            if (error != nil) {
                println("Error with JSON: \(error)")
                println(request)
                println(response)
            } else {
                let json = JSON(jsonData!)
                // Parse JSON
                let speed: Double = json["wind"]["speed"].doubleValue
                let direction = json["wind"]["deg"].doubleValue
                var weatherItems = Wind(vitesse: speed, directionEnDegrés: direction)
                println("Données sur le vent :")
                println("Direction: \(weatherItems.directionDegrés)° = \(weatherItems.directionRadians) rad")
                println("Vitesse: \(weatherItems.speed) m/s\n----------------- \n")
                //println(json)
                let weather = Weather(latitude: latitude, longitude: longitude, windObject: weatherItems)
                completionHandler(weather)
            }
        }
    }
}