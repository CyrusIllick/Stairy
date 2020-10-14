//
//  Ground.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/14/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit

class Ground: SKSpriteNode {
    
    //Mark: - Init
    
    init(size: CGSize) {
        
        
        let groundSize = CGSize(width: size.width, height: size.height)
        super.init(texture: nil, color: UIColor.white, size: groundSize)
        
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //Mark: - Setup
    
    func setup() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.isDynamic = false  //Put an ! to make sure there is no error on physicsbody
        physicsBody!.categoryBitMask = PhysicsCategory.Ground
        physicsBody!.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Coin
        physicsBody!.contactTestBitMask = PhysicsCategory.Player
    }
}
