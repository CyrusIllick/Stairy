//
//  StoreVC.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 8/2/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import UIKit

class StoreVC: UIViewController {
    
    //var playerData: [String: [String: Any]]!

    @IBOutlet weak var previousRect: UIButton!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var rectCost: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var rectView: UIView!
    
    @IBOutlet weak var BuyBtn: UIButton!
    
    @IBOutlet weak var coinsLabel: UILabel!
    
    //var coins = UserDefaults().integer(forKey: "coins")
    
    @IBOutlet weak var nextRect: UIButton!
    
    var playerData: [[String : Any]]!
    
    var colorIndex = 0
    
    override func viewDidLoad() {
        
        
        
        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 60/255, alpha: 0.7)
        
        super.viewDidLoad()
        
        
        
        //rectView.backgroundColor = UIColor.red
//
       self.backBtn.addTarget(self, action: #selector(self.dismissed), for: .touchUpInside)

        self.nextRect.addTarget(self, action: #selector(self.nextColor), for: .touchUpInside)
        
        self.previousRect.addTarget(self, action: #selector(self.prevColor), for: .touchUpInside)
        
        self.BuyBtn.addTarget(self, action: #selector(self.buy), for: .touchUpInside)
        

        
        if UserDefaults().string(forKey: "selected") == nil {
            UserDefaults().set("\(playerData[colorIndex]["name"] as! String)", forKey: "selected")
        }
        UserDefaults().set("owned", forKey: "\(playerData[colorIndex]["name"] as! String)")
        
        btnLabelUpdate()
        
        updateCoinCount()
        
        let colorInfo = playerData[colorIndex]
        
        
        name.text = colorInfo["name"] as? String
        rectCost.text = "\(colorInfo["cost"] as! Int)"
        rectView.backgroundColor = (colorInfo["color"] as! UIColor)
        


    }
    
    
    
    @objc func dismissed() {
        self.dismiss(animated: true, completion: nil)
        GameStartScene(size: view.frame.size).updateCoinCount()
    }
    
    @objc func nextColor() {
        colorIndex += 1
        
        if colorIndex == playerData.count {
            colorIndex = 0
        }
        
        
        let colorInfo = playerData[colorIndex]

        
        name.text = colorInfo["name"] as? String
        rectCost.text = "\(colorInfo["cost"] as! Int)"
        rectView.backgroundColor = (colorInfo["color"] as! UIColor)
        
        print(colorIndex)
        btnLabelUpdate()
        

    }
    
    
    @objc func prevColor() {
        colorIndex -= 1
        
        if colorIndex < 0 {
            colorIndex = playerData.count - 1
        }
        
        let colorInfo = playerData[colorIndex]
        
        name.text = colorInfo["name"] as? String
        rectCost.text = "\(colorInfo["cost"] as! Int)"
        rectView.backgroundColor = (colorInfo["color"] as! UIColor)
        
        print(colorIndex)
        btnLabelUpdate()
    }
    
    @objc func buy() {
        let selectedState = UserDefaults().string(forKey: "selected")
        let state = UserDefaults().string(forKey: "\(playerData[colorIndex]["name"] as! String)")
        if selectedState == "\(playerData[colorIndex]["name"] as! String)"{
            print("nothing to do here")
        }
        if state == "owned" {
            UserDefaults().set("\(playerData[colorIndex]["name"] as! String)", forKey: "selected")
        } else {
            var coins = UserDefaults().integer(forKey: "coins")
            coins -= playerData[colorIndex]["cost"] as! Int
            UserDefaults().set(coins, forKey: "coins")
            UserDefaults().set("owned", forKey: "\(playerData[colorIndex]["name"] as! String)")
            updateCoinCount()
            GameViewController().pushCoins(coins: UserDefaults().integer(forKey: "coins"))
            
        }
        
        btnLabelUpdate()
    }
    
    func btnLabelUpdate(){
        let selectedState = UserDefaults().string(forKey: "selected")
        let state = UserDefaults().string(forKey: "\(playerData[colorIndex]["name"] as! String)")
        
        if selectedState as! String  == "\(playerData[colorIndex]["name"] as! String)"{
            BuyBtn.setTitle("Selected", for: .normal)
        } else if state == "owned" {
            BuyBtn.setTitle("select",for: .normal)
        } else {
            BuyBtn.setTitle("Buy", for: .normal)
        }
    }
    
    func updateCoinCount() {
        let coins = UserDefaults().integer(forKey: "coins")
        coinsLabel.text = "\(coins) coins"
    }
    

    
}


