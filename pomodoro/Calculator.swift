//
//  Calculator.swift
//  sold
//
//  Created by Enrico Castelli on 29/11/2018.
//  Copyright © 2018 Enrico Castelli. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class Calculator {
    
    static func calculateDirection(x: CGFloat, y: CGFloat) -> SCNVector3 {
        let betterX = ((x/50) - 1)/5
        let betterY = ((y/50) - 1)/5
        return SCNVector3(x: Float(betterX), y: 0, z: Float(betterY))
    }
    
    static func calculateTurn(x: CGFloat, y: CGFloat, rotationW: CGFloat) -> SCNVector4 {
        var angle = CGFloat()
        let point = CGPoint(x: x - 50, y: y - 50)
        if point.x.sign == .minus {
            angle = (atan(point.y/point.x) + CGFloat.pi/2)
        } else {
            angle = (atan(point.y/point.x) + CGFloat.pi/2 + CGFloat.pi)
        }
        if abs(angle - .pi * 2 - angle) < abs(angle - angle) {
            angle -= .pi * 2
        }
        var finalAngle = angle
        let opt = abs(angle - .pi * 2)
        let optM = opt  - rotationW
        if optM < abs(angle - rotationW) {
            finalAngle -= .pi * 2
        }
        return SCNVector4(0, -1, 0, finalAngle)
    }
    
    static func calculateShoot(angle: CGPoint) -> CGPoint? {
        let speedX : CGFloat = {
            if angle.x > 5 { return 10 }
            else if angle.x < -5 { return -10 }
            else { return 0 }
        }()
        let speedY : CGFloat = {
            if angle.y > 5 { return 10 }
            else if angle.y < -5 { return -10 }
            else { return 0 }
        }()
        guard speedX != 0 || speedY != 0 else { return nil }
        return CGPoint(x: speedX, y: speedY)
    }
    
    static func calculateGranadeShoot(angle: CGPoint) -> CGPoint {
        let speedX : CGFloat = {
            if angle.x > 5 { return 10 }
            else if angle.x < -5 { return -10 }
            else { return 0 }
        }()
        let speedY : CGFloat = {
            if angle.y > 5 { return 10 }
            else if angle.y < -5 { return -10 }
            else { return 0 }
        }()
        return CGPoint(x: speedX, y: speedY)
    }
    
}
