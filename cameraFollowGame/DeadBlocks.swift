//
//  DeadBlocks.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/25/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit

class DeadBlocks: SKSpriteNode{
    
    var point: CGPoint
    //Mark: - Init
    init(point: CGPoint){
        self.point = point
        super.init(texture: nil, color: UIColor.cyan, size: CGSize(width: 10, height: 10))
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //Mark: - Setup
    func setup() {
        position = point

        zPosition = 5
        physicsBody = SKPhysicsBody(rectangleOf: size)
        
        
    }
    
    func blockColor(blockColor: UIColor){
       color = blockColor
    }
    
    
}
