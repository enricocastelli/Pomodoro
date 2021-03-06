//
//  GameViewController.swift
//  sold
//
//  Created by Enrico Castelli on 26/11/2018.
//  Copyright © 2018 Enrico Castelli. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    var pomodoro: Pomodoro!
    var cameraNode: CameraNode!
    var scnView: SCNView!
    var scene: SCNScene!
    
    var controller: ControllerView!
    var direction = SCNVector3(0, 0, 0)
    var rotation = SCNVector4(0, 0, 0, 0)
    var angle = CGPoint(x: 0, y: 0)
        
    var events : [Event] = [
        FruitEvent(position: SCNVector3(0, 1, -30), fruit: .Apple),
        FruitEvent(position: SCNVector3(-6, 1, -70), fruit: .Pear),
        HideSpotEvent(position: SCNVector3(0, 1, -76), z: true),
        FruitEvent(position: SCNVector3(36, 1, -80), fruit: .Pear),
        FruitEvent(position: SCNVector3(36, 1, -74), fruit: .Pear),
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        // create a new scene
        scene = SCNScene(named: "art.scnassets/scene.scn")!
        scene.physicsWorld.contactDelegate = ContactManager.main
        // create and add a camera to the scene
        cameraNode = NodeCreator.createCamera()
        scene.rootNode.addChildNode(cameraNode)
        // retrieve the SCNView
        scnView = (self.view as! SCNView)
        scnView.scene = scene
        scnView.allowsCameraControl = false
        scnView.delegate = self
        pomodoro = NodeCreator.createPomodoro()
        scene.rootNode.addChildNode(pomodoro)
        addControllers()
        addBoundaries()
    }
    
    func executeEvent(event: Event) {
        if let fruit = event as? FruitEvent {
            executeFruitEvent(event: fruit)
        } else if let hideSpot = event as? HideSpotEvent {
            addImp(pos: event.position, z: hideSpot.z)
        }
    }
    
    func executeFruitEvent(event: FruitEvent) {
        switch event.fruit {
        case .Apple:
            let apple = NodeCreator.createApple()
            apple.position = event.position
            addImp(pos: SCNVector3(event.position.x, 1, event.position.z + 5), z: false)
            scene.rootNode.addChildNode(apple)
            apple.delegate = self
            apple.activate()
        case .Pear:
            let pear = NodeCreator.createPear()
            pear.position = event.position
            scene.rootNode.addChildNode(pear)
            pear.delegate = self
            pear.activate()
        }
    }
    
    func rotateCamera(positive: Bool) {
        cameraNode.rotate(positive: positive)
        controller.rotateJoystick(angle: cameraNode.eulerAngles.y)
    }
    
    func addBoundaries() {
        for boundary in NodeCreator.createBoundaries() {
            scene.rootNode.addChildNode(boundary)
        }
    }
    
    func addImp(pos: SCNVector3, z: Bool) {
        let geo = SCNBox(width: 5, height: 3, length: 1, chamferRadius: 0)
        let impediment = SCNNode(geometry: geo)
        impediment.position = pos
        if z { impediment.eulerAngles = SCNVector3(0, CGFloat.pi/2, 0) }
        impediment.physicsBody = SCNPhysicsBody.static()
        impediment.physicsBody?.categoryBitMask = Collider.impediment
        impediment.physicsBody?.collisionBitMask = Collider.floor | Collider.bullet | Collider.player
        scene.rootNode.addChildNode(impediment)
    }

    func addControllers() {
        controller = ControllerView(frame: view.frame, delegate: self)
        view.addSubview(controller)
    }
    
    func shoot() {
        guard let shootForce = Calculator.calculateShoot(angle: angle) else { return }
        let bulletNode = NodeCreator.createBullet(position: pomodoro.position)
        scene.rootNode.addChildNode(bulletNode)
        bulletNode.physicsBody?.applyForce(SCNVector3(shootForce.x, 0, shootForce.y), asImpulse: true)
        let action = SCNAction.wait(duration: 1)
        bulletNode.runAction(action) {
            bulletNode.removeFromParentNode()
        }
    }
    
    func shootGranade() {
        let shootForce = Calculator.calculateGranadeShoot(angle: angle)
        let bulletNode = NodeCreator.createGranade(position: pomodoro.position)
        scene.rootNode.addChildNode(bulletNode)
        bulletNode.physicsBody?.applyForce(SCNVector3(shootForce.x, pomodoro.trowingForce, shootForce.y), asImpulse: true)
        let action = SCNAction.wait(duration: 4)
        bulletNode.runAction(action) {
            if let explode = SCNParticleSystem(named: "explode", inDirectory: "art.scnassets/anims") {
                bulletNode.addParticleSystem(explode)
            }
            bulletNode.removeFromParentNode()
        }
    }
    
    func shootPrecision() {
        let bulletNode = NodeCreator.createPrecisionBullet(position: pomodoro.position)
        scene.rootNode.addChildNode(bulletNode)
        bulletNode.physicsBody?.applyForce(SCNVector3(angle.x, 0, angle.y), asImpulse: true)
        let action = SCNAction.wait(duration: 1)
        bulletNode.runAction(action) {
            bulletNode.removeFromParentNode()
        }
    }
}

extension GameViewController : SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let targetPosition = SCNVector3(x: pomodoro.presentation.position.x + Values.xDistance, y: pomodoro.presentation.position.y + Values.yDistance, z: pomodoro.presentation.position.z + Values.zDistance)
        var cameraPosition = cameraNode.position
        let camDamping:Float = 0.3
        let xComponent = cameraPosition.x * (1 - camDamping) + targetPosition.x * camDamping
        let yComponent = cameraPosition.y * (1 - camDamping) + targetPosition.y * camDamping
        let zComponent = cameraPosition.z * (1 - camDamping) + targetPosition.z * camDamping
        cameraPosition = SCNVector3(x: xComponent, y: yComponent, z: zComponent)
        cameraNode.position = cameraPosition
        if checkTest() {
        pomodoro.position = SCNVector3(pomodoro.position.x + direction.x, 0, pomodoro.position.z + direction.z)
        pomodoro.rotation = rotation
        }
        if pomodoro.isPointing {
            cameraNode.rotation = SCNVector4(0, -1, 0, rotation.w + Float.pi)
        }
        checkOpp()
    }
    
    func checkTest() -> Bool {
        let newPos = SCNVector3(pomodoro.position.x + direction.x, 0, pomodoro.position.z + direction.z)
        let hittest = scene.rootNode.hitTestWithSegment(from: pomodoro.position, to: newPos, options: nil)
        guard hittest.count > 0 else { return true }
        for ind in 0...hittest.count - 1 {
            let hit = hittest[ind]
            if hit.node.physicsBody?.categoryBitMask == Collider.impediment {
                return false
            }
        }
        return true
    }
    
    func checkOpp() {
        for index in 0...events.count - 1 {
            let event = events[index]
            if abs(pomodoro.position.z) > abs(event.position.z) - Float(Values.zFar) && event.added == false {
                event.added = true
                executeEvent(event: event)
                break
            }
        }
    }
}

extension GameViewController: JoyDelegate {
   
    func didMoveTo(x: CGFloat, y: CGFloat) {
        if !pomodoro.isTrowing && !pomodoro.isPointing {
            pomodoro.isMoving()
            direction = Calculator.calculateDirection(x: x, y: y)
        }
        rotation = Calculator.calculateTurn(x: x, y: y, rotationW: CGFloat(pomodoro.rotation.w))
        angle = CGPoint(x: x - 50, y: y - 50)
    }
    
    func didStop() {
        direction = SCNVector3(x: 0, y: 0, z: 0)
        pomodoro.isStill()
    }
    
    func didShoot() {
        switch pomodoro.army {
        case .pomodorino:
            pomodoro.shoot()
            shoot()
        case .granade:
            pomodoro.prepareGranade()
        case .precision:
            if !pomodoro.isPointing {
                pomodoro.isPointing = true
                cameraNode.configureForPointing()
                controller.insertShooterView()
            } else {
                shootPrecision()
            }
        default:
            break
        }
    }
    
    func didPressForce(force: CGFloat) {
        guard pomodoro.army == .granade else { return }
        didStop()
        pomodoro.isTrowing = true
        pomodoro.trowingForce = force*2
    }
    
    func didStopShoot() {
        if pomodoro.isTrowing {
            pomodoro.shootGranade()
            shootGranade()
        }
        pomodoro.isTrowing = false
        pomodoro.trowingForce = 0
    }
    
    func didChangeArmy() {
        if pomodoro.army == .pomodorino {
            pomodoro.army = .granade
        } else if pomodoro.army == .granade {
            pomodoro.army = .precision
        } else {
            if pomodoro.isPointing {
                controller.removeShooterView()
                cameraNode.removePointing()
            }
            pomodoro.isPointing = false
            pomodoro.army = .pomodorino
        }
        controller.didChangeArmy(army: pomodoro.army)
    }
}

extension GameViewController: FruitDelegate {
    
    func shouldShoot(fruit: Fruit) {
        guard scene.rootNode.childNodes.contains(fruit) else {
            fruit.deactivate()
            return }
        guard fruit.position.z + 40 > pomodoro.position.z else { return }
        fruit.movingTo(pos: pomodoro.position.x)
        
        let bulletNode = NodeCreator.createOppBullet(position: fruit.presentation.position, color: fruit.color)
        guard let shootForce = Calculator.calculateShoot(angle: CGPoint(x: CGFloat(pomodoro.position.x - bulletNode.position.x), y: CGFloat(pomodoro.position.z - bulletNode.position.z))) else { return }

        scene.rootNode.addChildNode(bulletNode)
        bulletNode.physicsBody?.applyForce(SCNVector3(shootForce.x * 2, 0, shootForce.y * 2), asImpulse: true)
    }
}

