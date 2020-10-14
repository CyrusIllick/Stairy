//
//  deadly.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/15/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit

class deadly: SKSpriteNode {
    
    //Mark: - Init
    
    init() {
        
        
        let deadlyObjSize = CGSize(width: 8, height: 30)
        
        super.init(texture: SKTexture(imageNamed: "spike"), color: UIColor.clear, size: deadlyObjSize)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // Mark: - Setup
    
    
    func setup() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width - 3, height: size.height - 15))
        
        physicsBody!.isDynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.DeadlyObject
        physicsBody!.collisionBitMask = PhysicsCategory.None
        physicsBody!.contactTestBitMask = PhysicsCategory.Player
    }
    
    
}
