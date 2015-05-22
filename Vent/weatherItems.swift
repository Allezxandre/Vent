//
//  weatherItems.swift
//  HMWK 8
//
//  Created by Marcia Elyseu on 4/23/15.
//  Copyright (c) 2015 Marcia Elyseu. All rights reserved.
//

import Foundation

class Wind {
    let speed: Double?
    let direction: Double?
    
    init(vitesse: Double, direction: Double) {
        self.speed = vitesse
        self.direction = direction
    }
}