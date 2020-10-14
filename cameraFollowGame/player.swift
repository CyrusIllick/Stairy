//
//  player.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/14/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    
    
    //Mark: - Init()
    init() {
        
        let playerSize = CGSize(width: 20, height: 40)
        super.init(texture: nil, color: UIColor.cyan, size: playerSize)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //Mark: - setup
    
    func setup() {
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.allowsRotation = false
        physicsBody!.categoryBitMask = PhysicsCategory.Player
        physicsBody!.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Stair | PhysicsCategory.DeadlyObject
        physicsBody!.contactTestBitMask = PhysicsCategory.Coin | PhysicsCategory.DeadlyObject | PhysicsCategory.Stair | PhysicsCategory.Ground
    }
    
    func changeColor(playerColor: UIColor){
        color = playerColor
    }
    
    
}
