//
//  NodeCreator.swift
//  sold
//
//  Created by Enrico Castelli on 29/11/2018.
//  Copyright © 2018 Enrico Castelli. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class NodeCreator {
    
    static func createCamera() -> CameraNode {
        
        let cameraNode = CameraNode(node: SCNNode())
        cameraNode.position = SCNVector3(x: 0, y: Values.yDistance, z: Values.zDistance)
        cameraNode.eulerAngles = SCNVector3(-CGFloat.pi/8, 0, 0)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        cameraNode.addChildNode(lightNode)
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        cameraNode.addChildNode(ambientLightNode)
        return cameraNode
    }
    
    static func createBoundaries() -> [SCNNode] {
        let geo = SCNBox(width: 100, height: 6, length: 4, chamferRadius: 0)
        let tallGeo = SCNBox(width: 100, height: 20, length: 4, chamferRadius: 0)
        let leftNode = SCNNode(geometry: geo)
        leftNode.position = SCNVector3(-20, 2, -40)
        boundarySetup(node: leftNode, z: true)
        let rightNode = SCNNode(geometry: geo)
        rightNode.position = SCNVector3(20, 2, -20)
        boundarySetup(node: rightNode, z: true)
        let backNode = SCNNode(geometry: geo)
        backNode.opacity = 0.1
        backNode.position = SCNVector3(0, 2, 10)
        boundarySetup(node: rightNode, z: false)
        let frontNode = SCNNode(geometry: geo)
        frontNode.position = SCNVector3(28, 2, -90)
        boundarySetup(node: frontNode, z: false)
        let frontRightNode = SCNNode(geometry: tallGeo)
        frontRightNode.position = SCNVector3(68, 2, -68)
        boundarySetup(node: frontRightNode, z: false)
        let lastLeftNode = SCNNode(geometry: geo)
        lastLeftNode.position = SCNVector3(76, 2, -138)
        boundarySetup(node: lastLeftNode, z: true)
        let lastRightNode = SCNNode(geometry: tallGeo)
        lastRightNode.position = SCNVector3(108, 2, -118)
        boundarySetup(node: lastRightNode, z: true)
        let lastNode = SCNNode(geometry: tallGeo)
        lastNode.position = SCNVector3(85, 2, -160)
        boundarySetup(node: lastNode, z: false)
        return [leftNode, rightNode, backNode, frontNode, frontRightNode, lastLeftNode, lastRightNode, lastNode]
    }
    
    static func boundarySetup(node: SCNNode, z: Bool) {
        if z { node.eulerAngles = SCNVector3(0, CGFloat.pi/2, 0) }
        node.physicsBody = SCNPhysicsBody.kinematic()
        node.physicsBody?.categoryBitMask = Collider.impediment
    }
    
    static func createPomodoro() -> Pomodoro {
        let boxScene = SCNScene(named: "art.scnassets/player.scn")!
        let box = boxScene.rootNode.childNodes.first!
        let pomodoro = Pomodoro(node: box)
        pomodoro.position = SCNVector3(0, 0, 0)
        pomodoro.physicsBody = SCNPhysicsBody.dynamic()
        pomodoro.physicsBody?.categoryBitMask = Collider.player
        pomodoro.physicsBody?.collisionBitMask = Collider.floor | Collider.impediment | Collider.bulletOpp
        pomodoro.name = "player"
        return pomodoro
    }
    
    static func createPear() -> Pear {
        let geo = SCNCone(topRadius: 0, bottomRadius: 2, height: 4)
        geo.materials.first?.diffuse.contents = UIColor.yellow
        let box = SCNNode(geometry: geo)
        let node = Pear(node: box)
        node.physicsBody = SCNPhysicsBody.dynamic()
        node.name = "opponent"
        node.physicsBody?.contactTestBitMask = Collider.bullet | Collider.opponent
        node.physicsBody?.categoryBitMask = Collider.opponent
        node.physicsBody?.collisionBitMask = Collider.floor | Collider.bullet | Collider.impediment
        return node
    }
    
    static func createApple() -> Apple {
        let geo = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0.7)
        geo.materials.first?.diffuse.contents = UIColor.green
        let box = SCNNode(geometry: geo)
        let node = Apple(node: box)
        node.physicsBody = SCNPhysicsBody.dynamic()
        node.name = "opponent"
        node.physicsBody?.contactTestBitMask = Collider.bullet | Collider.opponent
        node.physicsBody?.categoryBitMask = Collider.opponent
        node.physicsBody?.collisionBitMask = Collider.floor | Collider.bullet | Collider.impediment
        return node
    }
    
    static func createOrange() -> Orange {
        let geo = SCNSphere(radius: 1.3)
        geo.materials.first?.diffuse.contents = UIColor.orange
        let box = SCNNode(geometry: geo)
        let node = Orange(node: box)
        node.physicsBody = SCNPhysicsBody.dynamic()
        node.name = "opponent"
        node.physicsBody?.contactTestBitMask = Collider.bullet | Collider.opponent
        node.physicsBody?.categoryBitMask = Collider.opponent
        node.physicsBody?.collisionBitMask = Collider.floor | Collider.bullet | Collider.impediment
        return node
    }
    
    static func createPlum() -> Plum {
        let geo = SCNSphere(radius: 3)
        geo.materials.first?.diffuse.contents = UIColor.purple
        let box = SCNNode(geometry: geo)
        let node = Plum(node: box)
        node.physicsBody = SCNPhysicsBody.dynamic()
        node.name = "opponent"
        node.physicsBody?.contactTestBitMask = Collider.bullet | Collider.opponent
        node.physicsBody?.categoryBitMask = Collider.opponent
        node.physicsBody?.collisionBitMask = Collider.floor | Collider.bullet | Collider.impediment
        return node
    }
    
    static func createBullet(position: SCNVector3, opponent: Fruit?) -> SCNNode {
        let geo = SCNSphere(radius: 0.4)
        geo.materials.first?.diffuse.contents = opponent?.color ?? UIColor.orange
        let bulletNode = SCNNode(geometry: geo)
        bulletNode.position = SCNVector3(position.x, 1, position.z)
        bulletNode.physicsBody = SCNPhysicsBody.dynamic()
        bulletNode.physicsBody?.contactTestBitMask = (opponent == nil) ?
             Collider.opponent | Collider.impediment  :
            Collider.bulletOpp | Collider.player | Collider.impediment
        bulletNode.physicsBody?.isAffectedByGravity = false
        bulletNode.physicsBody?.categoryBitMask = (opponent == nil) ? Collider.bullet : Collider.bulletOpp
        bulletNode.physicsBody?.collisionBitMask = (opponent == nil) ?
            Collider.bulletOpp | Collider.opponent | Collider.impediment | Collider.bullet :
            Collider.bulletOpp | Collider.player | Collider.impediment | Collider.bullet
        bulletNode.physicsBody?.continuousCollisionDetectionThreshold = 1
        bulletNode.name = "bullet"
        return bulletNode
    }
    
    static func createGranade(position: SCNVector3, opponent: Fruit?) -> SCNNode {
        let geo = SCNCapsule(capRadius: 0.3, height: 1)
        geo.materials.first?.diffuse.contents = UIColor.red
        let bulletNode = SCNNode(geometry: geo)
        bulletNode.position = SCNVector3(position.x, 1, position.z)
        bulletNode.physicsBody = SCNPhysicsBody.dynamic()
        bulletNode.physicsBody?.contactTestBitMask = (opponent == nil) ?
            Collider.opponent | Collider.impediment  :
            Collider.bulletOpp | Collider.player | Collider.impediment
        bulletNode.physicsBody?.isAffectedByGravity = true
        bulletNode.physicsBody?.categoryBitMask = (opponent == nil) ? Collider.granade : Collider.granadeOpp
        bulletNode.physicsBody?.collisionBitMask = (opponent == nil) ?
            Collider.bulletOpp | Collider.opponent | Collider.impediment | Collider.bullet | Collider.floor :
            Collider.bulletOpp | Collider.player | Collider.impediment | Collider.bullet | Collider.floor
        bulletNode.physicsBody?.continuousCollisionDetectionThreshold = 1
        bulletNode.name = "bullet"
        return bulletNode
    }
    
    static func createPrecisionBullet(position: SCNVector3, opponent: Fruit?) -> SCNNode  {
        let geo = SCNSphere(radius: 0.2)
        geo.materials.first?.diffuse.contents = UIColor.blue
        let bulletNode = SCNNode(geometry: geo)
        let yHeight: Float = opponent == nil ? 2.5 : 1
        bulletNode.position = SCNVector3(position.x, yHeight, position.z)
        bulletNode.physicsBody = SCNPhysicsBody.dynamic()
        bulletNode.physicsBody?.contactTestBitMask = (opponent == nil) ?
            Collider.opponent | Collider.impediment  :
            Collider.bulletOpp | Collider.player | Collider.impediment
        bulletNode.physicsBody?.isAffectedByGravity = false
        bulletNode.physicsBody?.categoryBitMask = (opponent == nil) ? Collider.precision : Collider.precisionOpp
        bulletNode.physicsBody?.collisionBitMask = (opponent == nil) ?
            Collider.bulletOpp | Collider.opponent | Collider.impediment | Collider.bullet :
            Collider.bulletOpp | Collider.player | Collider.impediment | Collider.bullet
        bulletNode.physicsBody?.continuousCollisionDetectionThreshold = 1
        bulletNode.name = "bullet"
        return bulletNode
    }
    
}
