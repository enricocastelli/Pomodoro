

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
        let loc = touch.location(in: self)
        let radius: CGFloat = 50
        let distance = hypot(loc.x - 50, loc.y - 50)
        if distance <= radius {
            pointer.center = loc
        } else {
            pointer.center = CGPoint(
                x: 50 + (loc.x - 50) / distance * radius,
                y: 50 + (loc.y - 50) / distance * radius
            )
        }
        print(loc)
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

