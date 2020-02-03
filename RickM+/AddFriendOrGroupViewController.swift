//
//  AddFriendOrGroupViewController.swift
//  RickM+
//
//  Created by RickSun on 2020/2/1.
//  Copyright © 2020 RickSun. All rights reserved.
//

import UIKit
import Foundation

class AddFriendOrGroupViewController: UIViewController {
    
    @IBOutlet weak var searchFriendTableView: UITableView!
    
    @IBAction func searchFriendAction(_ sender: Any) {
        
        searchFriendTableView.isHidden = !searchFriendTableView.isHidden
        
    }
    
    
    @IBOutlet var creatOrSearchCompanyGroup: [UIButton]!
    
    @IBAction func createOrSearchGroupAction(_ sender: Any) {
        
        for creatOrSearchCompanyGroupBtn in creatOrSearchCompanyGroup {
            
            creatOrSearchCompanyGroupBtn.isHidden = !creatOrSearchCompanyGroupBtn.isHidden
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchFriendTableView.delegate = self
        
        searchFriendTableView.dataSource = self
        
    }
}

extension AddFriendOrGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchFriend", for: indexPath) as? SearchFriendTableViewCell else {
            
            return UITableViewCell()
            
        }
        
        cell.searchFriendName.text = "Ken"
        
        return cell
    }
}
