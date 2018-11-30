//
//  ControllerView.swift
//  pomodoro
//
//  Created by Enrico Castelli on 30/11/2018.
//  Copyright © 2018 Enrico Castelli. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class ControllerView: UIView {
    
    var shooter: ShootButton!
    var joystick: Joystick!
    var armyButton: ArmyButton!
    var lifeProgress: UIProgressView!
    var shooterView: UIView?

    var delegate: GameViewController
    
    init(frame: CGRect, delegate: GameViewController) {
        self.delegate = delegate
        super.init(frame: frame)
        setup()
        addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        joystick = Joystick(frame: CGRect(x: 16, y: UIScreen.main.bounds.height - 116, width: 100, height: 100))
        joystick.delegate = delegate
        addSubview(joystick)
        shooter = ShootButton(frame: CGRect(x: UIScreen.main.bounds.width - 116, y: UIScreen.main.bounds.height - 116, width: 100, height: 100))
        shooter.delegate = delegate
        addSubview(shooter)
        armyButton = ArmyButton(frame: CGRect(x: shooter.frame.origin.x - 64, y: UIScreen.main.bounds.height - 64, width: 40, height: 40), army: .pomodorino)
        armyButton.delegate = delegate
        addSubview(armyButton)
        lifeProgress = UIProgressView(frame: CGRect(x: 20, y: 16, width: 200, height: 20))
        addSubview(lifeProgress)
    }
    
    func addGesture() {
        let doupleTap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        doupleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doupleTap)
        doupleTap.delegate = self
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        let loc = sender.location(in: self)
        delegate.rotateCamera(positive: (loc.x >= center.x))
    }
    
    func rotateJoystick(angle: Float) {
        joystick.transform = CGAffineTransform.init(rotationAngle: CGFloat(angle))
    }
    
    func didChangeArmy(army: Army) {
        armyButton.army = army
    }
    
    func insertShooterView() {
        guard shooterView == nil else { return }
        shooterView = UIView(frame: frame)
        let circle = createCircle(frame: CGRect(x: 0, y: 0
            , width: frame.height/2, height: frame.height/2))
        let smallCircle = createCircle(frame: CGRect(x: 0, y: 0
            , width: frame.height/8, height: frame.height/8))
        shooterView?.addSubview(circle)
        shooterView?.addSubview(smallCircle)
        insertSubview(shooterView!, belowSubview: joystick)
    }
    
    func removeShooterView() {
        joystick.transform = CGAffineTransform.init(rotationAngle: 0)
        shooterView?.removeFromSuperview()
        shooterView = nil
    }
    
    func createCircle(frame: CGRect) -> UIView {
        let circle = UIView(frame: frame)
        circle.layer.borderWidth = 5
        circle.layer.borderColor = UIColor.white.cgColor
        circle.frame.size.height = frame.height
        circle.frame.size.width = frame.width
        circle.layer.cornerRadius = frame.height/2
        circle.center = center
        return circle
    }
    
}

extension ControllerView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view!.isDescendant(of: shooter)) || (touch.view!.isDescendant(of: joystick)) || (touch.view!.isDescendant(of: armyButton)) {
            return false
        }
        return true
    }
    
}
