//
//  CoinView.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 8/2/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit


class CoinView: SKNode{
    
    let point: CGPoint
    
    let coinLabel: Label
    
    let starCoin = SKSpriteNode(texture: SKTexture(imageNamed: "starCoin"), color: UIColor.yellow, size: CGSize(width: 20, height: 20))
    
    let scale: CGFloat = 0.2
    
    init(point: CGPoint) {
        self.point = point
        

        
        let coins = UserDefaults().integer(forKey: "coins")
        coinLabel = Label(fontNamed: "Avenir-Heavy", theText: "\(coins)", theFontSize: 30, place: point, color: UIColor.yellow)
        
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        position = point
        
        addChild(coinLabel)
        
        starCoin.position = CGPoint(x: coinLabel.position.x - coinLabel.frame.size.width / 2 - starCoin.size.width / 2 - 5, y: point.y + coinLabel.frame.size.height / 2)

        addChild(starCoin)
        
    }
    
    func updateCoinView() {
        starCoin.position = CGPoint(x: coinLabel.position.x - coinLabel.frame.size.width / 2 - starCoin.size.width / 2 - 5, y: point.y + coinLabel.frame.size.height / 2)
    }
    
    func updateCoinText() {
        let coins = UserDefaults().integer(forKey: "coins")
        coinLabel.text = "\(coins)"
        updateCoinView()
    }
    
}
