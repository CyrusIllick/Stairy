//
//  GameScene.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/14/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import SpriteKit
import GameplayKit

var score: Int = 0



class GameScene: SKScene, SKPhysicsContactDelegate, GameViewControllerDelegate {
    func trigger() {
        return
    }
    
    func reloadName() {
        return
    }
    
    
    let player: Player
    
    let cameraNode: SKCameraNode
    
    var landscapes = [Landscape]()
    
    let beginBlock: BeginBlock
    
    var ableJump: Bool = false
    
    var lastUpdateTime: CFTimeInterval = 0
    
    var scoreLabel: Label
    
    let stairCase: staircase
    
    var lengthMoveUp: Int
    
    var playerSpeed: Int
    
    var startedPlaying: Bool
    
    var tapToStartLabel: Label
    
    var mydelegate: GameSceneDelegate!
    
    var gravity: Float
    
    var impulse: Int
    
    //INDEX OF THE STAIR THAT THE CHARACTER IS ON
    var iStair: Int
    
    var coins: Int
    
    let coinView: CoinView
    
    var deadBlockColor: UIColor = UIColor.cyan
    
    
    
    //MARK: - Init
    override init(size: CGSize) {
        player = Player()
        
        cameraNode = SKCameraNode()
        
        beginBlock = BeginBlock(size: size)
        
        score = 0
        
        scoreLabel = Label(fontNamed: "Avenir-Heavy", theText: "\(score)", theFontSize: 50, place: CGPoint(x: 0, y: 0), color: UIColor.white)
        
        tapToStartLabel = Label(fontNamed: "Avenir-Heavy", theText: "Tap To Start", theFontSize: 40, place: CGPoint(x: -size.width / 2, y: size.height * 1.75), color: UIColor.white)
        
        stairCase = staircase(size: size)
        
        lengthMoveUp = Int(size.width) / 120 * 30
        
        coinView = CoinView(point: CGPoint(x: 0, y: 0))
        
        playerSpeed = 0
        
        startedPlaying = false
        
        gravity = -9.8
        
        impulse = 13
        
        iStair = 0
        
        coins = UserDefaults().integer(forKey: "coins")
        
        super.init(size: size)
        
        //cant add stuff to scene until super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        mydelegate.setDelegate(sceneName: "GameScene", scene: self)
        let color = mydelegate.getPlayerColor()
        player.changeColor(playerColor: color)
        deadBlockColor = color
    }
    
    
    //Mark: Setup
    func setup() {
        
        physicsWorld.contactDelegate = self
        
        addChild(player)
        player.position.x = -size.width / 2
        player.position.y = size.height * 1.6
        player.zPosition = 4
        
        addChild(cameraNode)
        camera = cameraNode //This line makes it so the scene view is based on the cameranode
        cameraNode.position.x = size.width / 2
        cameraNode.position.y = size.height / 2
        
        addChild(stairCase)
        stairCase.position.x = size.width * 0.1
        stairCase.position.y = size.height * 1.5
        stairCase.zPosition = 3
        
        scoreLabel.name = "scoreLabel"
        cameraNode.addChild(scoreLabel)
        scoreLabel.position.x = position.x
        scoreLabel.position.y = position.y + self.size.height * 0.35
        
        cameraNode.addChild(coinView)
        coinView.position.y = position.y + self.size.height * 0.4
        coinView.position.x = position.x + self.size.width * -0.3
        
            
            
        addChild(tapToStartLabel)
        
        beginBlock.position.x = -size.width
        beginBlock.position.y = 0
        beginBlock.name = "beginBlock"
        addChild(beginBlock)
        
    
        
        
        for i in 0..<2 {
            let landscape = Landscape(size: size) //Consider making the size you input to be bigger
            landscape.position.x = CGFloat(i) * size.width
            landscape.position.y = CGFloat(i) * CGFloat(lengthMoveUp)
            landscape.resetLandscape()
            landscapes.append(landscape)
            addChild(landscape)
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !startedPlaying {
            playerSpeed = 130
            startedPlaying = true
            
            //tapToStartLabel.removeFromParent()
            tapToStartLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()]))
        }
        
        if ableJump {
            player.physicsBody!.applyImpulse(CGVector(dx: 0, dy: impulse))
            ableJump = false
        }
        
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    //Update: - Update
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        var deltaTime = currentTime - lastUpdateTime
        if deltaTime > 1 {
            deltaTime = 1 / 60
        }
        lastUpdateTime = currentTime
        
        
        //THESE ARE OTHER WAYS THAT I COULD HAVE HAD THE PLAYER MOVE
        
        // player.physicsBody!.velocity = CGVector(dx: 2400 * deltaTime, dy: 0)
        //player.physicsBody?.applyForce(CGVector(dx: 30, dy: 0))
        
        player.position.x += CGFloat(playerSpeed) * CGFloat(deltaTime)
        
        cameraNode.position.x = player.position.x
        cameraNode.position.y = player.position.y
        
        scrollLandscapes()
        
        
    }
    
    func scrollLandscapes() {
        for landscape in landscapes {
            let dx = landscape.position.x - cameraNode.position.x
            if dx < -(landscape.size.width + self.size.width / 2) {
                
                landscape.position.x += landscape.size.width * 2
                
                landscape.position.y += CGFloat(lengthMoveUp)
                
                //Ugly code I know but it fixes an anoying bug where the stairs don't align
                if landscapes[0].position.y == landscapes[1].position.y {
                    if landscapes[0].position.x > landscapes[1].position.x{
                        landscapes[0].position.y += CGFloat(lengthMoveUp)
                    } else {
                        landscapes[1].position.y += CGFloat(lengthMoveUp)
                    }
                }
                
                if let firstNode = childNode(withName: "beginBlock") {
                    firstNode.removeFromParent()
                }
                
                landscape.resetLandscape()
                
                stairCase.updateStairs(cameraNodePoint: cameraNode.position, sizeOfScreen: size)
                
            }
        }
    }
    
    
    
    
    //Mark: - Physics Contact
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        //assigns a variable to each object
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
            
        }
        else {
            body1  = contact.bodyB
            body2 = contact.bodyA
        }
        
        if collision == PhysicsCategory.Coin | PhysicsCategory.Player {
            print("** Contact Player and Coin! **")
            coins += 1
            if score < 28 {
                playerSpeed += 5

            } else if score < 70{
                playerSpeed += 3
                
                gravity -= 1
                impulse += 1
                
                self.physicsWorld.gravity = CGVector(dx: 0, dy: Int(gravity))
            }


            body2.node?.removeFromParent()
            
            coinView.coinLabel.text = "\(coins)"
            coinView.updateCoinView()
            
            
        } else if collision == PhysicsCategory.DeadlyObject | PhysicsCategory.Player {
            
            let positionPlayer = player.position
            
            
            body1.node?.removeFromParent()
            
            
            deadAnim(point: positionPlayer)
            
            UserDefaults().set(coins, forKey: "coins")
            
            let sceneToMoveto = GameOverScene(size: self.size)
            sceneToMoveto.scaleMode = self.scaleMode
            sceneToMoveto.mydelegate = self.mydelegate
            let myTransition = SKTransition.fade(withDuration: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.view!.presentScene(sceneToMoveto, transition: myTransition)
            }
            
            
        } else if collision == PhysicsCategory.Stair | PhysicsCategory.Player {
            
           // stairCase.figureStairOn(playerPoint: player.getPosition(), viewSize: size)
            for stair in stairCase.stairs{
                if stair.colorChanged == false && stair.position.y + stairCase.position.y < player.position.y - player.size.height / 2 {
                    stair.color = UIColor(red: 200/255, green: 200/255, blue: 255/255, alpha: 1.0)
                    stair.colorChanged = true
                    score += 1
                    scoreLabel.text = "\(score)"
                }
                
            }
            
            ableJump = true
            
        } else if collision == PhysicsCategory.Ground | PhysicsCategory.Player {
            ableJump = true
        }
    }
    
    func deadAnim(point: CGPoint) {
        for _ in 0..<30 {
            let block = DeadBlocks(point: point)
            block.blockColor(blockColor: deadBlockColor)
            addChild(block)
        }
    }
    
    
    
}
