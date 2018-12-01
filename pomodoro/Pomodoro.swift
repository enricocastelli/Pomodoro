//
//  Pomodoro.swift
//  sold
//
//  Created by Enrico Castelli on 29/11/2018.
//  Copyright © 2018 Enrico Castelli. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class Pomodoro : SCNNode {
    
    var coreNode: SCNNode
    var actionTimer = Timer()
    
    var shouldBreath = true
    var shouldMove = false
    var life = 1.0
    var army = Army.pomodorino
    
    var isTrowing = false
    var isPointing = false
    
    var trowingForce : CGFloat = 0.0 {
        didSet {
            updateArrow()
        }
    }
    var trowingLength : CGFloat = 0.0
    
    var granade: SCNNode?
    var trowingArrow: SCNNode?

    
    init(node: SCNNode) {
        coreNode = node
        super.init()
        addChildNode(coreNode)
        start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        actionTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(timerTrigger), userInfo: nil, repeats: true)
    }
    
    func isStill() {
        reset()
        shouldBreath = true
        shouldMove = false
    }
    
    func isMoving() {
        shouldBreath = false
        shouldMove = true
    }
    
    func shoot() {
        guard let leftEye = coreNode.childNode(withName: "leftEye", recursively: true), let rightEye = coreNode.childNode(withName: "rightEye", recursively: true)
            else { return }
        leftEye.scale.y = 0.05
        rightEye.scale.y = 0.05
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
            rightEye.scale.y = 1
            leftEye.scale.y = 1
        })
    }
    
    func prepareGranade() {
        guard granade == nil && trowingArrow == nil else { return }
        granade = NodeCreator.createGranade(position: coreNode.position)
        granade?.physicsBody?.isAffectedByGravity = false
        addTrowingArrow()
        addChildNode(granade!)
    }
    
    func addTrowingArrow() {
        let geo = SCNPyramid(width: 1, height: 3, length: 0.1)
        trowingArrow = SCNNode(geometry: geo)
        trowingArrow?.eulerAngles = SCNVector3(Float.pi/2.5 , 0, 0)
        trowingArrow?.opacity = 0.5
        trowingArrow?.position = SCNVector3(coreNode.position.x, 0, coreNode.position.z + 1)
        addChildNode(trowingArrow!)
    }
    
    func updateArrow() {
        guard let trowingArrow = trowingArrow else { return }
        trowingArrow.scale = SCNVector3(1, 1 + (trowingForce/7), 1)
    }
    
    func shootGranade() {
        granade?.removeFromParentNode()
        granade = nil
        trowingArrow?.removeFromParentNode()
        trowingArrow = nil
    }
    
    func reset() {
        let walkReset = SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.5)
        coreNode.runAction(walkReset)
    }
    
    @objc func timerTrigger() {
        if shouldBreath && !shouldMove {
            let breatheAction = SCNAction.scale(by: 1.1, duration: 0.4)
            coreNode.runAction(breatheAction) {
                self.coreNode.runAction(breatheAction.reversed())
            }
        } else if !shouldBreath && shouldMove {
            let walkRight = SCNAction.rotateTo(x: 0.05, y: 0, z: 0.3, duration: 0.2)
            let walkBack = SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.18)
            let walkLeft = SCNAction.rotateTo(x: -0.05, y: 0, z: -0.3, duration: 0.2)
            let jumpAction = SCNAction.moveBy(x: 0.05, y: 0.1, z: 0, duration: 0.4)
            
            coreNode.runAction(jumpAction) {
                self.coreNode.runAction(jumpAction.reversed())
            }
            coreNode.runAction(walkRight) {
                self.coreNode.runAction(walkBack) {
                    if self.shouldMove {
                        self.coreNode.runAction(walkLeft) {
                            self.coreNode.runAction(walkBack)
                        }
                    }
                }
            }
        }
    }
    
}

