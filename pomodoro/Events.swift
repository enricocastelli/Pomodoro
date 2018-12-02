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
