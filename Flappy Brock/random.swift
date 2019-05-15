//
//  random.swift
//  Flappy Brock
//
//  Created by JOHN BEISNER on 5/15/19.
//  Copyright © 2019 clc.fuhler. All rights reserved.
//

import Foundation
import CoreGraphics


public extension CGFloat{
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
}
