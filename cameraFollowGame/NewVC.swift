//
//  NewVC.swift
//  cameraFollowGame
//
//  Created by Cyrus Illick on 7/26/19.
//  Copyright © 2019 CyrusIllick. All rights reserved.
//

import UIKit
import Firebase

class NewVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var cellData: [String: Any]!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cells.count == 0 {
            getCells()
        }
        print(cells.count)
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cells[indexPath.row]
        if cell.rankLabel.text == "Label" {
            cell.loadcell()
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    var cells = [Highscorecell]()
    @IBOutlet weak var tabview: UITableView!
    
    
    @IBOutlet weak var backbtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 200/255, green: 226/255, blue: 255/255, alpha: 1.0)

        backbtn.addTarget(self, action: #selector(dismisst), for: .touchUpInside)

        tabview.dataSource = self
        tabview.delegate = self
        tabview.frame = self.view.frame
        tabview.backgroundColor = UIColor(red: 200/255, green: 226/255, blue: 255/255, alpha: 1.0)
        tabview.separatorStyle = .none
        self.view.addSubview(tabview)
        getCells()

        
    }
    
    func getCells() {
        let value = cellData!
        self.cells.removeAll()
        for key in value.keys {
            if Int(key) != nil {
                let cell = self.tabview.dequeueReusableCell(withIdentifier: "scorecell") as! Highscorecell
                if let truval = value[key]! as? [String: Any] {
                    if let highscore = truval["highScore"] as? Int, let truname = truval["name"] as? String {
                        cell.data = ["name": truname, "score": "\(highscore)"]
                    } else if let highscore = truval["highScore"] as? Int {
                        cell.data = ["name": "Default", "score": "\(highscore)"]
                        
                    } else if let truname = truval["name"] as? String {
                        cell.data = ["name": truname, "score": "0"]
                        
                    } else {
                        cell.data = ["name": "Default", "score": "0"]
                        
                    }
                    
                }
                cell.backgroundView = UIImageView(image: UIImage(named: "storeOwned"))
                self.cells.append(cell)
            }
        }
        self.cells.sort(by: { (cell1, cell2) in
            return Int(cell1.data["score"]!)! > Int(cell2.data["score"]!)!
        })
        for cello in self.cells {
            cello.data["rank"] = "\(String(describing: self.cells.firstIndex(of: cello)!.advanced(by: 1)))"
        }
        self.tabview.reloadData()
    }
    
    @objc func dismisst() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}
