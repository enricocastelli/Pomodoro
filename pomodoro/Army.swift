//
//  Army.swift
//  sold
//
//  Created by Enrico Castelli on 29/11/2018.
//  Copyright © 2018 Enrico Castelli. All rights reserved.
//

import Foundation

enum Army {
    case pomodorino
    case granade
    case sugo
    case precision
    
    func duration() -> Double {
        switch self {
        case .pomodorino:
            return 0.8
        case .granade:
            return 3.5
        case .precision:
            return 0.4
        case .sugo:
            return 1
        }
    }
}
