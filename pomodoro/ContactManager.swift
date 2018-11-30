//
//  ContactDelegate.swift
//  sold
//
//  Created by Enrico Castelli on 29/11/2018.
//  Copyright © 2018 Enrico Castelli. All rights reserved.
//

import Foundation
import SceneKit

class ContactManager: NSObject, SCNPhysicsContactDelegate {
    
    static let main = ContactManager()
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if contact.nodeB.name == "bullet" {
            bulletHandler(bullet: contact.nodeB, other: contact.nodeA)
        } else if contact.nodeA.name == "bullet" {
            bulletHandler(bullet: contact.nodeA, other: contact.nodeB)
        }
    }
    
    func bulletHandler(bullet: SCNNode, other: SCNNode) {
        if other.physicsBody?.categoryBitMask == Collider.opponent {
            bullet.removeFromParentNode()
            if let fruit = other as? Fruit {
                fruit.deactivate()
                fruit.die()
            }
        } else if other.physicsBody?.categoryBitMask == Collider.impediment {
            bullet.removeFromParentNode()
        } else if other.physicsBody?.categoryBitMask == Collider.player {
            if let pomodoro = other as? Pomodoro {
                pomodoro.life -= 0.2
            }
            bullet.removeFromParentNode()
        }
    }
    
}
