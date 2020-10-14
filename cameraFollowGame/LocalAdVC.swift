//
//  LocalAdVC.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/29/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import Foundation
import UIKit

class LocalAdVC: UIViewController {
    
    var adData = [String: Any]()
    
    
    //MARK: - Main.Storyboard LABELS AND BUTTON INITILIZERS
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var linkButton: UIButton!
    
    
    var adUrl: String! = "https://www.instagram.com/thecyrusillick/"
    
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "adBack")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        

        let length = adData.count
        let randomIndex = Int(arc4random() % UInt32(length))
        let nameArray = Array(adData.keys)
        
        let thisAd = adData[nameArray[randomIndex]] as! [String: Any]
        
        messageLabel.text = (thisAd["message"] as! String)
        messageLabel.sizeToFit()
        
        titleLabel.text = (thisAd["title"] as! String)
        titleLabel.sizeToFit()
        
        let buttonLabel = thisAd["linkType"] as! String
        linkButton.setTitle(buttonLabel, for: .normal)
        linkButton.layer.cornerRadius = 10
        linkButton.clipsToBounds = true
        
        adUrl = (thisAd["url"] as! String)
        
        exitButton.layer.cornerRadius = 20
        exitButton.clipsToBounds = true
        exitButton.alpha = 0
        
        linkButton.addTarget(self, action: #selector(clickLink), for: .touchUpInside)
        
        //User has to wait a certain amount of time before they can exit
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.exitButton.addTarget(self, action: #selector(self.dismissed), for: .touchUpInside)
            self.exitButton.alpha = 1.0
        })


    }
    
    
    //MARK: - BUTTON ACTIONS
    
    @objc func clickLink() {
        guard let myUrl = URL(string: adUrl) else { return }
        UIApplication.shared.open(myUrl)
    }
    
    @objc func dismissed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
