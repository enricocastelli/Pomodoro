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
    case Orange
}

class Fruit: SCNNode {
    
    var impediment = false
    var isMoving = false
    var coreNode: SCNNode
    var color: UIColor = UIColor.white
    var delegate: FruitDelegate?
    var timer = Timer()
    var timerTime: Double = 1
    var army = Army.pomodorino
    var damageInflicting: Float = 1
    var life: Float = 1
    
    init(node: SCNNode) {
        coreNode = node
        super.init()
        addChildNode(coreNode)
        setup()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createNode() -> SCNNode {
        return SCNNode()
    }
    
    func setup() {
        // to be overriden
    }
    
    func activate() {
        timer = Timer.scheduledTimer(timeInterval: timerTime, target: self, selector: #selector(trigger), userInfo: nil, repeats: true)
    }
    
    func hit(damage: Float) {
        life = life - damage
        if life < 0 {
            deactivate()
            die()
        }
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
    
    override func setup() {
            color = UIColor.green
            impediment = true
            isMoving = true
            timerTime =  1.1
            damageInflicting = 0.8
    }

}


class Pear: Fruit {
    
    override func setup() {
        color = UIColor.yellow
        impediment = false
        isMoving = false
        timerTime =  0.8
        life = 1.5
    }

}

class Orange: Fruit {
    
    override func setup() {
        color = UIColor.orange
        impediment = false
        isMoving = true
        timerTime =  0.7
        army = .granade
        damageInflicting = 1.5
        life = 1.5
    }
}

class Plum: Fruit {
    
    override func setup() {
        color = UIColor.purple
        impediment = false
        isMoving = false
        timerTime =  0.5
        army = .pomodorino
        damageInflicting = 1.5
        life = 3
    }
}
