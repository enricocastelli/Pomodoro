//
//  Events.swift
//  sold
//
//  Created by Enrico Castelli on 29/11/2018.
//  Copyright © 2018 Enrico Castelli. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class Event: NSObject {
    var position: SCNVector3
    var added: Bool = false
    var specificFar: Float?
    
    init(position: SCNVector3) {
        self.position = position
    }
    
    static func getEasyEvents() -> [Event] {
        return [
            FruitEvent(position: SCNVector3(0, 1, -30), fruit: .Apple, sleeping: false),
            FruitEvent(position: SCNVector3(-6, 1, -70), fruit: .Pear, sleeping: false),
            HideSpotEvent(position: SCNVector3(0, 0, -76), z: true),
            FruitEvent(position: SCNVector3(36, 1, -80), fruit: .Pear, sleeping: false),
            FruitEvent(position: SCNVector3(36, 1, -74), fruit: .Pear, sleeping: false),
            FruitEvent(position: SCNVector3(87, 1, -100), fruit: .Pear, sleeping: true),
            FruitEvent(position: SCNVector3(94, 1, -100), fruit: .Pear, sleeping: true),
            FruitEvent(position: SCNVector3(91, 1, -100), fruit: .Orange, sleeping: true),
            HideSpotEvent(position: SCNVector3(80, 0, -89), z: false),
            FruitEvent(position: SCNVector3(92, 1, -140), fruit: .Plum, sleeping: true, specificFar: 20),
        ]
    }
    
    static func getHardEvents() -> [Event] {
        return [
            FruitEvent(position: SCNVector3(-2, 1, -30), fruit: .Apple, sleeping: false),
            FruitEvent(position: SCNVector3(2, 1, -33), fruit: .Apple, sleeping: false),
            FruitEvent(position: SCNVector3(-6, 1, -70), fruit: .Pear, sleeping: false),
            FruitEvent(position: SCNVector3(3, 1, -67), fruit: .Pear, sleeping: false),
            HideSpotEvent(position: SCNVector3(0, 0, -76), z: true),
            FruitEvent(position: SCNVector3(36, 1, -80), fruit: .Pear, sleeping: false),
            FruitEvent(position: SCNVector3(36, 1, -74), fruit: .Pear, sleeping: false),
            FruitEvent(position: SCNVector3(50, 1, -80), fruit: .Orange, sleeping: false),
            FruitEvent(position: SCNVector3(50, 1, -74), fruit: .Pear, sleeping: false),
            FruitEvent(position: SCNVector3(58, 1, -80), fruit: .Pear, sleeping: false),
            FruitEvent(position: SCNVector3(58, 1, -74), fruit: .Orange, sleeping: false),
            FruitEvent(position: SCNVector3(87, 1, -100), fruit: .Pear, sleeping: true),
            FruitEvent(position: SCNVector3(94, 1, -100), fruit: .Pear, sleeping: true),
            FruitEvent(position: SCNVector3(91, 1, -100), fruit: .Orange, sleeping: true),
            FruitEvent(position: SCNVector3(87, 1, -100), fruit: .Pear, sleeping: false),
            FruitEvent(position: SCNVector3(94, 1, -100), fruit: .Pear, sleeping: true),
            FruitEvent(position: SCNVector3(91, 1, -100), fruit: .Orange, sleeping: true),
            HideSpotEvent(position: SCNVector3(80, 0, -89), z: false),
            FruitEvent(position: SCNVector3(92, 1, -140), fruit: .Plum, sleeping: true)
        ]
    }
}

class FruitEvent: Event {
    var fruit: FruitType
    var sleeping: Bool
    
    init(position: SCNVector3, fruit: FruitType, sleeping: Bool, specificFar: Float? = nil) {
        self.fruit = fruit
        self.sleeping = sleeping
        super.init(position: position)
        self.specificFar = specificFar
    }
}

class HideSpotEvent: Event {
    var z: Bool
    
    init(position: SCNVector3, z: Bool) {
        self.z = z
        super.init(position: position)
    }
}

class BonusEvent: Event {
    
    var type: BonusType
    
    init(position: SCNVector3, type: BonusType) {
        self.type = type
        super.init(position: position)
    }
}

