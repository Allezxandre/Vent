//
//  weatherItems.swift
//  Vent
//
//  Created by Alexandre Jouandin on 22/04/15.
//  Copyright (c) 2015 Alexandre Jouandin. All rights reserved.
//

import Foundation

class Wind {
    let speed: Double
    let directionDegrés: Double
    var directionRadians: Double {
        return directionDegrés * M_PI / 180
    }
    
    init(vitesse: Double, directionEnDegrés direction: Double) {
        self.speed = vitesse
        self.directionDegrés = direction
    }
}