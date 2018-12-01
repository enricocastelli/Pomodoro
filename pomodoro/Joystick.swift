

import Foundation
import UIKit

protocol JoyDelegate {
    func didMoveTo(x: CGFloat, y: CGFloat)
    func didStop()
    func didShoot()
    func didPressForce(force: CGFloat)
    func didStopShoot()
    func didChangeArmy()
}

class Joystick: UIView {
    
    var pointer: UIView!
    var delegate: JoyDelegate?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if pointer == nil {
            layer.cornerRadius = 50
            layer.borderWidth = 3
            layer.borderColor = UIColor.yellow.cgColor
            pointer = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
            pointer.layer.cornerRadius = 8
            pointer.backgroundColor = UIColor.yellow
            self.addSubview(pointer)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var loc = touch.location(in: self)
        pointer.center = Calculator.calculatePointerCenter(loc: loc)
        if loc.y < 0 { loc.y = 0 }
        else if loc.y > 100 { loc.y = 100 }
        if loc.x < 0 { loc.x = 0 }
        else if loc.x > 100 { loc.x = 100 }
        delegate?.didMoveTo(x: loc.x, y: loc.y)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didStop()
    }
}

/*
 E = 100:50     //  90  // 2
 W = -100:50    // -90  // -2
 N = 50:100     // 180  // 0.5
 S = 50:-100    // 0    // -0.5
 
 */

