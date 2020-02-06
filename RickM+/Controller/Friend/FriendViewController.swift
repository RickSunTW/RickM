//
//  ViewController.swift
//  RickM+
//
//  Created by RickSun on 2020/1/30.
//  Copyright © 2020 RickSun. All rights reserved.
//

import UIKit
import Foundation

class FriendViewController: UIViewController {
    @IBOutlet weak var friendTableView: UITableView!
    
    @IBAction func addFriendOrGroupBtn(_ sender: Any) {
        performSegue(withIdentifier: "AddFriendOrGroup", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendTableView.delegate = self
        friendTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
}

extension FriendViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { return 4 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 1
        case 1: return 1
        case 2: return 2
        case 3: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendPersonal", for: indexPath) as? FriendPersonalTableViewCell else {
                
                return UITableViewCell()
                
            }
            
            cell.friendPersonalName.text = "Rick"
            
            cell.friendPersonalStatus.text = "努力寫Code中"
            
            return cell
            
        }
        else if indexPath.section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCompany", for: indexPath) as? FriendCompanyTableViewCell else {
                
                return UITableViewCell()
            }
            
            cell.friendCompanyName.text = "台灣大哥大"
            
            cell.friendCompanyStatus.text = "台灣大哥大與你生活在一起～"
            
            return cell
            
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCompanyGroup", for: indexPath) as? FriendCompanyGroupTableViewCell else {
                    
                    return UITableViewCell()
                }
                
                cell.friendCompanyGroupName.text = "PT Group"
                
                return cell
                
            } else if indexPath.row == 1 {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendGroup", for: indexPath) as? FriendGroupTableViewCell else {
                    
                    return UITableViewCell()
                }
                
                cell.friendGroupName.text = "text1～～～"
                
                return cell
                
            }
            
        }
        else if indexPath.section == 3 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCompany", for: indexPath) as? FriendCompanyTableViewCell else {
                
                return UITableViewCell()
            }
            
            cell.friendCompanyName.text = "Lisa"
            
            cell.friendCompanyStatus.text = "text2text2text2text2"
            
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
            
        case 0: return nil
            
        case 1: return "企業帳號(1)"
            
        case 2: return "群組(2)"
            
        case 3: return "好友(1)"
            
        default: return nil
            
        }
    }
}
