//
//  BeginBlock.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/23/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit

class BeginBlock: SKNode {
    
    //Mark: - Global Variables
    let size: CGSize
    let ground: Ground
    let background: SKSpriteNode

    
    
    //Mark: - Init
    init(size: CGSize) {
        
        
        self.size = size
        
        let hue = CGFloat(arc4random() % 1000) / 1000
        
        let backgroundSize = CGSize(width: size.width, height: size.height * 3)
        background = SKSpriteNode(color: UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 0.5), size: backgroundSize)
        
        
        
        ground = Ground(size: CGSize(width: size.width + 120, height: 30))
        
        
        super.init()
        
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Mark: - Setup
    func setup(){
        
        addChild(background)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        
        
        ground.position.x = size.width / 2
        ground.position.y = size.height * 1.5
        ground.zPosition = 2
        addChild(ground)

    }
    
    
}

