//
//  GameStartScene.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/23/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit
import Firebase
import UIKit
import SystemConfiguration




protocol GameViewControllerDelegate {
    func trigger()
    func reloadName()
}




class GameStartScene: SKScene, GameViewControllerDelegate {
    func trigger() {
        return
    }
    
    func reloadName() {
        (self.childNode(withName: "actualName") as! SKLabelNode).text = "Hello " +  (UserDefaults().value(forKey: "name") as! String)
    }
    
    
    
    
    
    var mydelegate: GameSceneDelegate!
    
    
    let playButton = SKSpriteNode(imageNamed: "playShadow.png")
    
    let changeNameButton = SKSpriteNode(imageNamed: "changeNameShadow")
    
    let leaderboardButton = SKSpriteNode(imageNamed: "leaderboardShadow")
    
    let storeButton = SKSpriteNode(imageNamed: "storeButtonShadow")
    
    let backgroundAnim: backgroundAnimation
    
    var playShaded = false
    var ledShaded = false
    var changeShaded = false
    var storeShaded = false
    
    
    var coinView: CoinView
    
    
    override init(size: CGSize) {



        backgroundAnim = backgroundAnimation(size: size)
        
        let coinPointInitial = CGPoint(x: 0, y: 0)
        
        coinView = CoinView(point: coinPointInitial)

        super.init(size: size)
        
        




    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        mydelegate.setDelegate(sceneName: "GameStartScene", scene: self)
        mydelegate.updateCheck()
        setup()
    }
    
    
    
    
    //Mark: - Setup
    func setup(){
        
        
        backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 60/255, alpha: 0.7)
        
        let nameLabelG = SKSpriteNode(imageNamed: "logoShadow")
        nameLabelG.position = CGPoint(x: size.width / 2, y: size.height * 0.8)
        nameLabelG.setScale(0.5)
        nameLabelG.zPosition = 5
        addChild(nameLabelG)
        
        
        
        let nameLabel = SKLabelNode(fontNamed: "Avenir-Heavy")
        if UserDefaults().value(forKey: "name") != nil {
            nameLabel.text = "Hello \(UserDefaults().value(forKey: "name")!)"
        } else {
            nameLabel.text = "Simply Hard"
        }
        nameLabel.name = "actualName"
        nameLabel.fontSize = 50
        nameLabel.fontColor = SKColor.white
        nameLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.6)
        nameLabel.zPosition = 100
        self.addChild(nameLabel)
        
        

        let coinPoint = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.9)
        coinView.position = coinPoint
        coinView.zPosition = 100
        
        addChild(coinView)
        
        addChild(backgroundAnim)
        backgroundAnim.position = CGPoint(x: 0, y: 0)
        backgroundAnim.zPosition = 1
        
       
        playButton.position = CGPoint(x: size.width / 2, y: size.height * 0.25)
        playButton.setScale(0.5)
        playButton.zPosition = 5
        playButton.color = UIColor.black
        addChild(playButton)
        
        
        changeNameButton.position = CGPoint(x: size.width * 0.3, y: size.height * 0.4)
        changeNameButton.setScale(0.25)
        changeNameButton.zPosition = 5
        changeNameButton.color = UIColor.black
        changeNameButton.colorBlendFactor = 0
        addChild(changeNameButton)
        
        leaderboardButton.position = CGPoint(x: size.width * 0.5, y: size.height * 0.375)
        leaderboardButton.setScale(0.25)
        leaderboardButton.zPosition = 5
        leaderboardButton.color = UIColor.black
        leaderboardButton.colorBlendFactor = 0
        addChild(leaderboardButton)
        
        storeButton.position = CGPoint(x: size.width * 0.7, y: size.height * 0.4)
        storeButton.setScale(0.25)
        storeButton.zPosition = 5
        storeButton.color = UIColor.black
        storeButton.colorBlendFactor = 0
        addChild(storeButton)
        
        
        let defaults = UserDefaults()
        let highScoreNumber = defaults.integer(forKey: "highScore")

        let leaderboardLabel = Label(fontNamed: "Avenir-Heavy", theText: "HighScore: \(highScoreNumber)", theFontSize: 50, place: CGPoint(x: self.size.width / 2, y: self.size.height / 2), color: UIColor.white)
        addChild(leaderboardLabel)
        
        
    }
    
    func updateCoinCount() {
        coinView.updateCoinText()
    }
    
    
    func unshadeButtons(){
        playShaded = false
        playButton.colorBlendFactor = 0
        ledShaded = false
        leaderboardButton.colorBlendFactor = 0
        changeShaded = false
        changeNameButton.colorBlendFactor = 0
        storeButton.colorBlendFactor = 0
        storeShaded = false
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if playButton.contains(touchLocation){
            
            playButton.colorBlendFactor = 1
            playShaded = true
        }
        
        if changeNameButton.contains(touchLocation){
            changeShaded = true
            changeNameButton.colorBlendFactor = 1
        }
        
        if leaderboardButton.contains(touchLocation){
            ledShaded = true
            leaderboardButton.colorBlendFactor = 1
        }
        
        if storeButton.contains(touchLocation){
            storeShaded = true
            storeButton.colorBlendFactor = 1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if playButton.contains(touchLocation) && playShaded{
            let sceneToMoveTo = GameScene(size: self.size)
            sceneToMoveTo.scaleMode = self.scaleMode
            sceneToMoveTo.mydelegate = self.mydelegate
            let myTransition = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        }
        
        if changeNameButton.contains(touchLocation)  && changeShaded {
            mydelegate.changeNameAlert(withTitle: "Change Name", message: "You can change your name to something else if you would like to")
        }
        
        if leaderboardButton.contains(touchLocation) && ledShaded {
            mydelegate.presentLeaderboard()
        }
        
        if storeButton.contains(touchLocation) && storeShaded {
            mydelegate.presentStore()
        }
        
        
        unshadeButtons()
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if arc4random() % 5 == 0 {
            backgroundAnim.updateShapes()
            updateCoinCount()
        }
    }
    
}
