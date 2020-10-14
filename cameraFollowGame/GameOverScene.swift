//
//  GameOverScene.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/22/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import StoreKit


class GameOverScene: SKScene, GameViewControllerDelegate {
    func trigger() {
        print("protocol method trigger is called")
        let defaults = UserDefaults()
        let coolHighScoreNumber = score
        defaults.set(coolHighScoreNumber, forKey: "highScore")
        self.mydelegate.pushData(score: coolHighScoreNumber)
    }
    
    func reloadName() {
        return
    }
    
    
    
    
    var backgroundAnim: backgroundAnimation
    
    var menuLabel = SKSpriteNode(imageNamed: "menuShadow")
    
    var againLabel = SKSpriteNode(imageNamed: "restartShadow")
    
    var againShaded = false
    var menuShaded = false
    
    var mydelegate: GameSceneDelegate!
    
    var posSize: CGSize
    
    
    //Mark: - Init
    override init(size: CGSize) {
        
        backgroundAnim = backgroundAnimation(size: size)
        
        posSize = size
        
        super.init(size: size)
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        mydelegate.setDelegate(sceneName: "GameOverScene", scene: self)
        
        setup()
        
    }
    
    
    //Mark: - Setup
    func setup() {
        
        backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 50/255, alpha: 0.8)
        
        let scoreLabel: Label = Label(fontNamed: "Avenir-Heavy", theText: "Score: \(score)", theFontSize: 40, place: CGPoint(x: size.width / 2, y: size.height * 0.6), color: UIColor.white)
        addChild(scoreLabel)
        
        againLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.25)
        againLabel.zPosition = 5
        againLabel.setScale(0.6)
        againLabel.color = UIColor.black
        againLabel.colorBlendFactor = 0
        addChild(againLabel)
        
        menuLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.4)
        menuLabel.setScale(0.5)
        menuLabel.color = UIColor.black
        menuLabel.colorBlendFactor = 0
        menuLabel.zPosition = 5
        addChild(menuLabel)
        
        let gameOverLabel = SKSpriteNode(imageNamed: "gameOverShadow")
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.8)
        gameOverLabel.setScale(0.65)
        gameOverLabel.zPosition = 5
        addChild(gameOverLabel)
        
        addChild(backgroundAnim)
        backgroundAnim.position = CGPoint(x: 0, y: 0)
        backgroundAnim.zPosition = 1
        
        
        //HIGHSCORE STUFF
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScore")
        
        if score > highScoreNumber{
            defaults.set(score, forKey: "highScore")
            highScoreNumber = defaults.integer(forKey: "highScore")
            
            if defaults.string(forKey: "name") == nil {
                self.mydelegate.showAlert(withTitle: "Name", message: "Enter a name for the leaderboard")
            }
            
            self.mydelegate.pushData(score: score)
            
        }
        
        let coinPoint = CGPoint(x: posSize.width * 0.1, y: posSize.height * 0.45)

        let coinView = CoinView(point: coinPoint)
    
        coinView.zPosition = 100
        
        addChild(coinView)
            
        
        
        let highScoreLabel = Label(fontNamed: "Avenir-Heavy", theText: "High Score: \(highScoreNumber)", theFontSize: 40, place: CGPoint(x: size.width / 2, y: size.height * 0.5), color: UIColor.white)
        addChild(highScoreLabel)
        
        
        //CODE TO ASK FOR THE PLAYER TO REVIEW THE APP
        var gamesPlayed = defaults.integer(forKey: "gamesPlayed")
        gamesPlayed += 1
        defaults.set(gamesPlayed, forKey: "gamesPlayed")
        
        if gamesPlayed == 5 || gamesPlayed == 50 || gamesPlayed == 100 {
            print("asking players to review the app")
            if #available( iOS 10.3,*){
                SKStoreReviewController.requestReview()
            }
        }
        
        
        
        //Present the local ad half the time and make sure that it does not show up when review is being asked for
        if arc4random() % 2 == 0 && gamesPlayed != 5 && gamesPlayed != 50 && gamesPlayed != 100{
            mydelegate.presentLocalAdView()
        } else {
          print("this where a real ad will go")
        }
        
        
        
        mydelegate.pushCoins(coins: UserDefaults().integer(forKey: "coins"))
        
        
    }
    
    
    
    
    //Mark: - Other functions
    
    func unShade(){
        againShaded = false
        menuShaded = false
        againLabel.colorBlendFactor = 0
        menuLabel.colorBlendFactor = 0
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
    
        
        if againLabel.contains(touchLocation) {
            againLabel.colorBlendFactor = 1
            againShaded = true
        }
        if menuLabel.contains(touchLocation) {
            menuShaded = true
            menuLabel.colorBlendFactor = 1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        
        
        if againLabel.contains(touchLocation) && againShaded{
            let sceneToMoveTo = GameScene(size: self.size)
            sceneToMoveTo.scaleMode = self.scaleMode
            sceneToMoveTo.mydelegate = self.mydelegate
            let myTransition = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        }
        if menuLabel.contains(touchLocation) && menuShaded{
            let sceneToMoveTo = GameStartScene(size: self.size)
            sceneToMoveTo.scaleMode = self.scaleMode
            sceneToMoveTo.mydelegate = self.mydelegate
            let myTransition = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        }
        
        unShade()
    }
    
    
    func randomColor() -> UIColor {
        let hue = CGFloat(arc4random() % 1000) / 1000
        return UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 0.5)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if arc4random() % 5 == 0 {
            backgroundAnim.updateShapes()
        }
    }
}




////
////  DataGrab.swift
////
////
////  Created by Cyrus Illick on 3/27/20.
////
//
//
//import Foundation
//import Firebase
//
//class DataGrab {
//
//    let who: String
//
//    init(username: String){
//        who = username
//    }
//
//    func getOwnCard(completion: @escaping (_ value: [String: Any]) -> Void){
//       // var value: [String: Any] = ["error": 1]
//
//        Database.database().reference().child("cards").child(who).observeSingleEvent(of: .value) { (snapshot) in
//            let value = snapshot.value as! [String: Any]
//            completion(value)
//        }
//
//    }
//
//}
//
//
////datagrab.getOwnCard{value in
////    let name: String = value["name"] as! String
////    let facebook: String = value["facebook"] as! String
////    let email: String = value["email"] as! String
////    let snap: String = value["snapchat"] as! String
////    let instagram: String = value["instagram"] as! String
////    let phone: String = value["phone"] as! String
////    let work: String = value["work"] as! String
////    let bio: String = value["bio"] as! String
////
////
////
////    self.addInfoToField(name, atGroup: 0, atIndex: 0)
////    self.addInfoToField(email, atGroup: 1, atIndex: 1)
////    self.addInfoToField(facebook, atGroup: 2, atIndex: 0)
////    self.addInfoToField(snap, atGroup: 2, atIndex: 2)
////    self.addInfoToField(instagram, atGroup: 2, atIndex: 1)
////    self.addInfoToField(phone, atGroup: 1, atIndex: 0)
////    self.addInfoToField(work, atGroup: 0, atIndex: 3)
////    self.addInfoToField(bio, atGroup: 0, atIndex: 2)
////
////    print("The name worked lmao", name)
////}
