//
//  CameraNide.swift
//  sold
//
//  Created by Enrico Castelli on 29/11/2018.
//  Copyright © 2018 Enrico Castelli. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class CameraNode: SCNNode {
    
    var coreNode: SCNNode
    var direction: Direction {
        get {
            switch self.eulerAngles.y.rounded() {
            case 0:
                return .North
            case -2, 5:
                return .East
            case 2:
                return .West
            case 3:
                return .South
            default:
                print(self.eulerAngles.y.rounded())
                return .Unknown
            }
        }
    }
    // storing eulerAngles so to come back to original position later
    var storedDirection: Direction?
    var originalRotation = SCNVector4(0, 0, 0, 0)
    var canRotate = true
    
    init(node: SCNNode) {
        coreNode = node
        super.init()
        addChildNode(coreNode)
        setup()
        originalRotation = self.rotation
    }
    
    func setup() {
        camera = SCNCamera()
        camera!.zFar = Values.zFar
        camera!.fStop = Values.fStop
        camera!.focalLength = Values.focalLength
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotate(positive: Bool) {
        guard canRotate else { return }
        if positive {
            eulerAngles.y = eulerAngles.y - Float.pi/2
        } else {
            eulerAngles.y = eulerAngles.y + Float.pi/2
        }
        
        if eulerAngles.y.rounded() == 6 { eulerAngles.y = 0 }
        if eulerAngles.y.rounded() == -3 { eulerAngles.y = Float.pi }
        updateCameraValues(direction: direction, isPointing: false)
    }
    
    func updateCameraValues(direction: Direction, isPointing: Bool) {
        switch direction {
        case .North:
            Values.xDistance = isPointing ? 0 : 0
            Values.zDistance = isPointing ? 0 : 13
            Values.yDistance = isPointing ? 1.5 : 4
        case .East:
            Values.xDistance = isPointing ? 0 : -13
            Values.zDistance = isPointing ? 0 : 0
            Values.yDistance = isPointing ? 1.5 : 4
        case .West:
            Values.xDistance = isPointing ? 0 : 13
            Values.zDistance = isPointing ? 0 : 0
            Values.yDistance = isPointing ? 1.5 : 4
        case .South:
            Values.xDistance = isPointing ? 0 : 0
            Values.zDistance = isPointing ? 0 : -13
            Values.yDistance = isPointing ? 1.5 : 4
        default:
            print("ERROR DIRECTION NOT FOUND!")
            break
        }
    }
    
    func configureForPointing() {
        canRotate = false
        print("@start Pointing direction: \(direction)")
        updateCameraValues(direction: direction, isPointing: true)
        storedDirection = direction
        camera!.vignettingPower = 0.7
        camera!.vignettingIntensity = 1
        camera!.saturation = 0.3
        camera!.fStop = 10
        camera!.focalLength = 40
    }
    
    func removePointing() {
        print("@removing Pointing. restoring direction: \(storedDirection)")
        canRotate = true
        updateCameraValues(direction: storedDirection ?? direction, isPointing: false)
        rotation = originalRotation
        eulerAngles.y = eulerForDirection(direction: storedDirection ?? direction)
        print("@restored direction \(eulerAngles.y)")
        camera!.vignettingPower = 0
        camera!.vignettingIntensity = 0
        camera!.saturation = 1
        camera!.fStop = Values.fStop
        camera!.focalLength = Values.focalLength
    }
    
    func eulerForDirection(direction: Direction) -> Float {
        switch direction {
        case .North:
            return 0
        case .East:
            return -Float.pi/2
        case .West:
            return Float.pi/2
        case .South:
            return Float.pi
        default:
            return 0
        }
    }
    
    
}
