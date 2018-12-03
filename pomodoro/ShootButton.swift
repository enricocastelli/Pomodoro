//
//  ShootButton.swift
//  sold
//
//  Created by Enrico Castelli on 29/11/2018.
//  Copyright © 2018 Enrico Castelli. All rights reserved.
//

import Foundation
import UIKit

class ShootButton: UIButton {
    
    var delegate: JoyDelegate?
    var count = 0
    var canShoot = true
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = 50
        layer.borderWidth = 3
        layer.borderColor = UIColor.red.cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard canShoot else { return }
        count += 1
        if count == 5 {
            recharge()
        } else {
            delegate?.didShoot()
        }
    }
    
    func recharge() {
        canShoot = false
        count = 0
        layer.borderColor = UIColor.white.cgColor
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            self.canShoot = true
            self.layer.borderColor = UIColor.red.cgColor
        })
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        delegate?.didPressForce(force: touch.force)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didStopShoot()
    }
    
}
