//
//  Stair.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/22/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit

class Stair: SKSpriteNode {
    
    //MARK: - Init
    //TODO: - I think that I should make it so the initilizer takes in the size of the stair
    
    //let sizeWhole: CGSize
    
    var colorChanged = false
    
    init(){
        //sizeWhole = fullSize
        
        let width = CGFloat(arc4random() % 12) * 10 + 60
        
        
        let stairSize = CGSize(width: width, height: 30)
        super.init(texture: nil, color: UIColor.white, size: stairSize)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.isDynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.Stair
        physicsBody!.collisionBitMask = PhysicsCategory.Player
        physicsBody!.contactTestBitMask = PhysicsCategory.Player
    }
    

    
}
