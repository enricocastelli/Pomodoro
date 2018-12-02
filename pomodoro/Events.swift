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
    
    init(position: SCNVector3) {
        self.position = position
    }
    
    static var easyEvents : [Event] = [
        FruitEvent(position: SCNVector3(0, 1, -30), fruit: .Apple, sleeping: false),
        FruitEvent(position: SCNVector3(-6, 1, -70), fruit: .Pear, sleeping: false),
        HideSpotEvent(position: SCNVector3(0, 0, -76), z: true),
        FruitEvent(position: SCNVector3(36, 1, -80), fruit: .Pear, sleeping: false),
        FruitEvent(position: SCNVector3(36, 1, -74), fruit: .Pear, sleeping: false),
        FruitEvent(position: SCNVector3(87, 1, -100), fruit: .Pear, sleeping: true),
        FruitEvent(position: SCNVector3(94, 1, -100), fruit: .Pear, sleeping: true),
        FruitEvent(position: SCNVector3(91, 1, -100), fruit: .Orange, sleeping: true),
        HideSpotEvent(position: SCNVector3(80, 0, -89), z: false),
        FruitEvent(position: SCNVector3(92, 1, -140), fruit: .Plum, sleeping: true),
        ]
    
    static var hardEvents : [Event] = [
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
        FruitEvent(position: SCNVector3(92, 1, -140), fruit: .Plum, sleeping: true),
        ]
}

class FruitEvent: Event {
    var fruit: FruitType
    var sleeping: Bool
    
    init(position: SCNVector3, fruit: FruitType, sleeping: Bool) {
        self.fruit = fruit
        self.sleeping = sleeping
        super.init(position: position)
    }
}

class HideSpotEvent: Event {
    var z: Bool
    
    init(position: SCNVector3, z: Bool) {
        self.z = z
        super.init(position: position)
    }
}

class CameraTurnEvent: Event {
    var direction: Direction
    
    init(position: SCNVector3, cameraTurn: Direction) {
        self.direction = cameraTurn
        super.init(position: position)
    }
}

