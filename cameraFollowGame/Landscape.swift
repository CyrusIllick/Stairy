//
//  Landscape.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/14/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit

class Landscape: SKNode {
    
    
    let ground: Ground
    let background: SKSpriteNode
    let contentNode: SKNode
    let size: CGSize
    //let stairCase: staircase
    
    
    
    
    //Mark: - Init
    
    init(size: CGSize) {
        self.size = size
        let hue = CGFloat(arc4random() % 1000) / 1000
        
        let backgroundSize = CGSize(width: size.width, height: size.height * 3)
        background = SKSpriteNode(color: UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 0.5), size: backgroundSize)
        
        //stairCase = staircase(size: size)
        
        
        ground = Ground(size: CGSize(width: size.width, height: 40))
        
        contentNode = SKNode()
        
        
        
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
        
        addChild(ground)
        ground.position.x = size.width / 2
        ground.position.y = size.width * 1.5
        ground.zPosition = 1
        
        
        addChild(contentNode)
    }
    
    
    //Mark: - Helper Functions
    
    func resetLandscape() {
        background.color = randomColor()
        
        //Other stuff to change the content of the landscape...
        
        contentNode.removeAllChildren()
        
        
        
        
        let coin = Coin()
        contentNode.addChild(coin)
        coin.position.x = CGFloat(arc4random() % UInt32(size.width))
        coin.position.y = ground.position.y + 1500
        
    }
    
    func randomColor() -> UIColor {
        let hue = CGFloat(arc4random() % 1000) / 1000
        return UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 0.5)
    }
}
