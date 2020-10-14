//
//  staircase.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/22/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit

class staircase: SKNode {
    
    var stairs = [Stair]()
    
    var deadlys = [deadly]()
    
    let size: CGSize
    
    //Mark: - Init
    init(size: CGSize) {
        self.size = size
        
        super.init()
        
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark: - Setup
    
    func setup() {
        var previousStairPosition: CGPoint = CGPoint(x: 0, y: 0)
        for i in 0..<20 {
            let stair = Stair()
            
            stair.position.y = previousStairPosition.y
            stair.position.x = previousStairPosition.x + stair.size.width / 2
            stairs.append(stair)
            addChild(stair)
            previousStairPosition.x = stair.position.x + stair.size.width / 2
            previousStairPosition.y = stair.position.y + stair.size.height
            
            
            if i != 0 {
                let deadlyObj = deadly()
                deadlyObj.size.height = stair.size.height - 10
                deadlyObj.position.x = stair.position.x - stair.size.width / 2 - deadlyObj.size.width / 2
                deadlyObj.position.y = stair.position.y
                deadlys.append(deadlyObj)
                addChild(deadlyObj)
                
            }
        }
    }
    
    
    func updateStairs(cameraNodePoint: CGPoint, sizeOfScreen: CGSize){
        for stair in stairs {
            let dx = stair.position.x - cameraNodePoint.x
            if dx < -(sizeOfScreen.width / 2 + stair.size.width) {
                stair.removeFromParent()
                stair.removeAllChildren()
                stair.removeAllActions()
                stairs.removeFirst()
                let newStair = Stair()
                newStair.position.y = stairs[stairs.count - 1].position.y + stairs[stairs.count - 1].size.height
                newStair.position.x = stairs[stairs.count - 1].position.x + stairs[stairs.count - 1].size.width / 2 + newStair.size.width / 2
                stairs.append(newStair)
                addChild(newStair)
                
                //CREAT NEW DEADLY TO GO WITH THE NEW STAIR
                let deadlyObj = deadly()
                deadlyObj.size.height = newStair.size.height - 10
                deadlyObj.position.x = newStair.position.x - newStair.size.width / 2 - deadlyObj.size.width / 2
                deadlyObj.position.y = newStair.position.y
                deadlys.append(deadlyObj)
                addChild(deadlyObj)
                
                
                //TO KEEP THE AMOUNT OF NODES TO A MINIMUM REMOVE OBJECTS
                deadlys.first?.removeFromParent()
                deadlys.first?.removeAllActions()
                deadlys.removeFirst()

            }
            
        }
    }

    
    
}


