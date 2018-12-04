//
//  Values.swift
//  sold
//
//  Created by Enrico Castelli on 29/11/2018.
//  Copyright © 2018 Enrico Castelli. All rights reserved.
//

import Foundation
import UIKit


class Values {
    
    static var zFar: Double = 70.0
    static var fStop: CGFloat = 100
    static var yDistance: Float = 4
    static var xDistance: Float = 0
    static var zDistance: Float = 13
    static var focalLength: CGFloat = 20.784608840942383
    
    
    static func reset() {
        zFar = 70.0
        fStop = 100
        yDistance = 4
        xDistance = 0
        zDistance = 13
        focalLength = 20.784608840942383
    }
    /*
     static var zFar: Double = 70.0
     static var fStop: CGFloat = 100
     static var yDistance: Float = 4
     static var zDistance: Float = 13
 */
}

enum Direction {
    case East
    case West
    case North
    case South
    
    case Unknown
}
