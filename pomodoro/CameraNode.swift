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
    
    init(node: SCNNode) {
        coreNode = node
        super.init()
        addChildNode(coreNode)
        setup()
    }
    
    func setup() {
        camera = SCNCamera()
        camera?.zFar = Values.zFar
        camera?.fStop = Values.fStop
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotate(positive: Bool) {
        if positive {
            eulerAngles.y = eulerAngles.y - Float.pi/2
        } else {
            eulerAngles.y = eulerAngles.y + Float.pi/2
        }
        
        if eulerAngles.y.rounded() == 6 { eulerAngles.y = 0 }
        if eulerAngles.y.rounded() == -3 { eulerAngles.y = Float.pi }
        updateCameraValues()
    }
    
    func updateCameraValues() {
        switch direction {
        case .North:
            Values.xDistance = 0
            Values.zDistance = 13
        case .East:
            Values.xDistance = -13
            Values.zDistance = 0
        case .West:
            Values.xDistance = 13
            Values.zDistance = 0
        case .South:
            Values.xDistance = 0
            Values.zDistance = -13
        default:
            break
        }
    }
    
}
