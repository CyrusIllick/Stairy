//
//  Coin.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/15/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit

class Coin: SKSpriteNode {
    
    
    
    //Mark: - Init
    
    init() {
        
        let coinSize = CGSize(width: 20, height: 20)
        
        
        super.init(texture: nil, color: UIColor.yellow, size: coinSize)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //Mark: - Setup
    
    func setup() {
        
        texture = SKTexture(imageNamed: "starCoin")
        
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        
        //physicsBody?.isDynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.Coin
        physicsBody!.collisionBitMask = PhysicsCategory.Stair | PhysicsCategory.Ground
        physicsBody!.contactTestBitMask = PhysicsCategory.Player
        
        zPosition = 5
    }
    
    
}
