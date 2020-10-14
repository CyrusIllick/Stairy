//
//  Label.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/22/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit

class Label: SKLabelNode {
    
    override init(){
        super.init()
    }
    
    init (fontNamed:String!, theText: String!, theFontSize: CGFloat!, place: CGPoint, color: UIColor){
        super.init(fontNamed: fontNamed)
        self.text = theText
        self.fontSize = theFontSize
        self.position = place
        self.fontColor = color
        zPosition = 5
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBack(size: CGSize) {
        let buttonBackColor = UIColor(red: 50/255, green: 50/255, blue: 100/255, alpha: 0.8)
        //let back = SKSpriteNode(texture: nil, color: buttonBackColor, size: CGSize(width: frame.width + 20, height: frame.height + 20))
        let backSize = CGSize(width: frame.width + 20, height: frame.height + 20)
        let back = SKShapeNode(rect: CGRect(x: -(backSize.width / 2), y: -(frame.height / 2) + 10 , width: backSize.width, height: backSize.height), cornerRadius: 10)
        back.fillColor = buttonBackColor
        //  back.position = CGPoint(x: 0, y: frame.height / 2)
        back.zPosition = 0
        addChild(back)
        
    }
}
