//
//  PhysicsCategory.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/15/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None: UInt32             = 0         //00000000000
    static let Player: UInt32           = 0b1       //00000000001
    static let Ground: UInt32           = 0b10      //00000000010
    static let Coin: UInt32             = 0b100     //00000000100
    static let DeadlyObject: UInt32     = 0b1000    //00000001000
    static let Stair: UInt32            = 0b10000   //00000010000
}
