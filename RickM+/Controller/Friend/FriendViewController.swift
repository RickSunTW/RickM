//
//  ViewController.swift
//  RickM+
//
//  Created by RickSun on 2020/1/30.
//  Copyright © 2020 RickSun. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher
import Firebase

class FriendViewController: UIViewController {
    @IBOutlet weak var friendTableView: UITableView!
    
    @IBAction func addFriendOrGroupBtn(_ sender: Any) {
        performSegue(withIdentifier: "AddFriendOrGroup", sender: nil)
    }
    var userProfileManager = UserProfileManager()
    var userData:Users?
    //    var userProfileData = [Users]()
    override func viewDidLoad() {
        super.viewDidLoad()
        friendTableView.delegate = self
        friendTableView.dataSource = self
        friendTableView.separatorStyle = .none
        userProfileManager.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userProfileManager.getUserData(id: "\(UserInfo.share.logInUserUid)")
        
    }
}

extension FriendViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { return 4 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 1
        case 1: return 1
        case 2: return 2
        case 3: return UserInfo.share.colleagueFriendsName.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendPersonal", for: indexPath) as? FriendPersonalTableViewCell else {
                
                return UITableViewCell()
                
            }
            
            cell.friendPersonalName.text = userData?.name
            
            cell.friendPersonalStatus.text = userData?.status
            
            if let personalPhoto = userData?.photoURL{
                guard let url = URL(string: personalPhoto) else {
                    return UITableViewCell()
                }
                
                let resource = ImageResource(downloadURL: url)
                
                cell.friendPersonalImage.kf.setImage(with: resource, placeholder: nil)
                cell.friendPersonalImage.contentMode = .scaleToFill
                
            }
            
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
            
            cell.friendCompanyName.text = UserInfo.share.colleagueFriendsName[indexPath.row]
            
            cell.friendCompanyStatus.text = UserInfo.share.colleagueFriendsStatus[indexPath.row]
            
            cell.friendCompanyImage.kf.setImage(with: UserInfo.share.colleagueFriendsPhoto[indexPath.row])
            
            cell.friendCompanyImage.contentMode = .scaleToFill
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            
            //            ShowUserProfile
            
            self.performSegue(withIdentifier: "ShowUserProfile", sender: nil)
            
            //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileVC")
            //
            //            vc?.modalPresentationStyle = .fullScreen
            //
            //            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    
    
}


extension FriendViewController: UserProfileManagerDelegate {
    
    func manager(_ manager: UserProfileManager, didgetUserData: Users) {
        
        self.userData = didgetUserData
        
        userProfileManager.getFriends(friendsemail: UserInfo.share.saveFriends)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.friendTableView.reloadData()
        }
    }
    
    func manager(_ manager: UserProfileManager, didFailWith error: Error) {
        
        print(error.localizedDescription)
        
    }
    
}
