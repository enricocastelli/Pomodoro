//
//  ArmyButton.swift
//  sold
//
//  Created by Enrico Castelli on 29/11/2018.
//  Copyright © 2018 Enrico Castelli. All rights reserved.
//

import Foundation
import UIKit

class ArmyButton: UIButton {
    
    var delegate: JoyDelegate?
    var army: Army {
        didSet {
            setup()
        }
    }
    var color: UIColor {
        get {
            switch army {
            case .pomodorino:
                return UIColor.orange
            case .granade:
                return UIColor.purple
            case .precision:
                return UIColor.blue
            case .sugo:
                return UIColor.white
            }
        }
    }
    
    init(frame: CGRect, army: Army) {
        self.army = army
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = color.cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didChangeArmy()
    }
    
    

}
