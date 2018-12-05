//
//  NodeExtension.swift
//  pomodoro
//
//  Created by Enrico Castelli on 02/12/2018.
//  Copyright © 2018 Enrico Castelli. All rights reserved.
//

import Foundation
import SceneKit
import UIKit

extension SCNNode {
    
    func shootBullet(army: Army, force: SCNVector3) {
        physicsBody?.applyForce(force, asImpulse: true)
        explode(army: army, direct: false)
    }
    
    func explode(army: Army, direct: Bool) {
        let duration = direct ? 0 : army.duration()
        if army == .granade {
            let action = SCNAction.wait(duration: duration)
            runAction(action) {
                if let explode = SCNParticleSystem(named: "explode", inDirectory: "art.scnassets/anims") {
                    self.addParticleSystem(explode)
                }
            }
            let action2 = SCNAction.wait(duration: duration + 0.3)
            runAction(action2) {
                self.removeFromParentNode()
            }
        } else {
            let action = SCNAction.wait(duration: duration)
            runAction(action) {
                self.removeFromParentNode()
            }
        }
    }
}
