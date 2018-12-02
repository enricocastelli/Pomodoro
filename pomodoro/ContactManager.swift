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
            if let fruit = other as? Fruit, (
                bullet.physicsBody?.categoryBitMask == Collider.bullet ||
                bullet.physicsBody?.categoryBitMask == Collider.granade ||
                bullet.physicsBody?.categoryBitMask == Collider.precision )
                
            {
                fruit.hit(damage: getDamageFromBullet(bullet: bullet))
                bullet.removeFromParentNode()
            }
        } else if other.physicsBody?.categoryBitMask == Collider.impediment {

        } else if other.physicsBody?.categoryBitMask == Collider.player, (
            bullet.physicsBody?.categoryBitMask == Collider.bulletOpp ||
                bullet.physicsBody?.categoryBitMask == Collider.granadeOpp ||
                bullet.physicsBody?.categoryBitMask == Collider.precisionOpp )
        {
            if let pomodoro = other as? Pomodoro {
                pomodoro.hit(damage: getDamageFromBullet(bullet: bullet))
                bullet.removeFromParentNode()
            }
        }
    }
    
    func getDamageFromBullet(bullet: SCNNode) -> Float {
        switch bullet.physicsBody?.categoryBitMask {
        case Collider.bullet:
            return 1
        case Collider.granade:
            return 1.5
        case Collider.precision:
            return 1.5
        default:
            return 1
        }
    }
    
}
