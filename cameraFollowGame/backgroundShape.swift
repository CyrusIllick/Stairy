//
//  backgroundShape.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/25/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit

class backgroundShape: SKSpriteNode {
    
    var viewSize: CGSize
    
    
    //Mark: - Init
    init(size: CGSize) {
        
        viewSize = size

        
        let color = UIColor(hue: CGFloat(arc4random() % 1000) / 1000, saturation: 1, brightness: 1, alpha: 0.3)
        let shapeSize = CGSize(width: 20, height: 20)
        super.init(texture: nil, color: color, size: shapeSize)
        
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark: - Setup
    func setup() {
        let randomX = CGFloat(arc4random() % UInt32(viewSize.width))
        let randomY = CGFloat(arc4random() % UInt32(viewSize.height))
        position = CGPoint(x: randomX, y: randomY)
    }
    
    
}
