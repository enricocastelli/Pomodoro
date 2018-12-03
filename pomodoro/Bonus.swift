//
//  Bonus.swift
//  pomodoro
//
//  Created by Enrico Castelli on 03/12/2018.
//  Copyright © 2018 Enrico Castelli. All rights reserved.
//

import Foundation
import SceneKit
import UIKit

enum BonusType {
    case finish
}


class Bonus: SCNNode {
    
    var coreNode: SCNNode
    var type: BonusType
    var activated = false
    
    init(node: SCNNode, type: BonusType) {
        coreNode = node
        self.type = type
        super.init()
        addChildNode(coreNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activate() {
        activated = true
        let anim = CABasicAnimation(keyPath: "light.intensity")
        anim.fromValue = 0
        anim.toValue = 500
        anim.duration = 1.5
        anim.autoreverses = true
        anim.repeatCount = .infinity
        addAnimation(anim, forKey: nil)
    }
    
}
