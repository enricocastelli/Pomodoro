//
//  Pear.swift
//  sold
//
//  Created by Enrico Castelli on 28/11/2018.
//  Copyright © 2018 Enrico Castelli. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

protocol FruitDelegate {
    func shouldShoot(fruit: Fruit)
}

enum FruitType {
    case Apple
    case Pear
}

class Fruit: SCNNode {
    
    var impediment = false
    var isMoving = false
    var coreNode: SCNNode
    var color: UIColor = UIColor.white
    var delegate: FruitDelegate?
    var timer = Timer()
    var timerTime: Double = 1
    
    init(node: SCNNode) {
        coreNode = node
        super.init()
        addChildNode(coreNode)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createNode() -> SCNNode {
        return SCNNode()
    }
    
    func activate() {
        timer = Timer.scheduledTimer(timeInterval: timerTime, target: self, selector: #selector(trigger), userInfo: nil, repeats: true)
    }
    
    func deactivate() {
        timer.invalidate()
    }
    
    func die() {
        let particle = SCNParticleSystem(named: "brokeh", inDirectory: "art.scnassets/anims")
        particle?.particleColor = color
        addParticleSystem(particle!)
        let act = SCNAction.fadeOut(duration: 0.2)
        runAction(act) {
            self.removeFromParentNode()
        }
    }
    
    func movingTo(pos: Float) {
        guard isMoving else { return }
        let action = SCNAction.move(to: SCNVector3(pos, position.y, position.z), duration: 0.3)
        runAction(action)
    }
    
    @objc func trigger() {
        delegate?.shouldShoot(fruit: self)
    }
}

class Apple: Fruit {
    
    override var color: UIColor { get {
            return UIColor.green
        } set {}}
    override var impediment: Bool { get {
        return true
        } set {}}
    override var isMoving: Bool { get {
        return true
        } set {}}
    override var timerTime: Double { get {
        return 1.1
        } set {}}

}


class Pear: Fruit {
    
    override var color: UIColor { get {
        return UIColor.yellow
        } set {}}
    override var impediment: Bool { get {
        return false
        } set {}}
    override var isMoving: Bool { get {
        return false
        } set {}}
    override var timerTime: Double { get {
        return 0.8
        } set {}}
    
}
