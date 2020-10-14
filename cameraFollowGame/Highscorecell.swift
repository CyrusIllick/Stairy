//
//  Highscorecell.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/26/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import UIKit

class Highscorecell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    var data = [String: String]()
    
    override func awakeFromNib() {
        loadcell()
        // Initialization code
    }
    
    func loadcell() {
        if data["name"] != nil {
            nameLabel.text = data["name"]
        }
        if data["score"] != nil {
            scoreLabel.text = data["score"]
        }
        if data["rank"] != nil {
            rankLabel.text = data["rank"]
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
