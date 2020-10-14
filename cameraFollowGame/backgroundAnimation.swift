//
//  backgroundAnimation.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/25/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit

class backgroundAnimation: SKNode{
    
    var size: CGSize
    
    var shapes = [backgroundShape]()
    
    
    //Mark: - Init
    init(size: CGSize) {
        
        self.size = size
        
        super.init()
        
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark: - setup
    func setup() {
        for _ in 0..<20 {
            let shape = backgroundShape(size: size)
            addChild(shape)
            shapes.append(shape)
        }
    }
    
    func updateShapes() {
 
            let fadeOut = SKAction.fadeOut(withDuration: 1)
            let removingSequence = SKAction.sequence([fadeOut, SKAction.removeFromParent()])
            shapes[0].run(removingSequence)
            shapes.removeFirst()
            let shape = backgroundShape(size: size)
            addChild(shape)
            shapes.append(shape)

    }
    
    
    
    
    
    
    
}
