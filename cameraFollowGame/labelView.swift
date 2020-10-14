//
//  labelView.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/16/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit

class labelView: SKNode {
    
    let scoreLabel: SKLabelNode
    
    
    //Mark: - Init
    
    override init(){
        
        scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
    }
    
    
    
}
