//
//  KeyModel.swift
//  RickM+
//
//  Created by RickSun on 2020/2/11.
//  Copyright © 2020 RickSun. All rights reserved.
//

import Foundation
import Kingfisher


class UserInfo {
    var logInUserUid = String()
    var saveFriends = [String]()
    var normalFriendsPhoto = [ImageResource]()
    var colleagueFriendsPhoto = [ImageResource]()
    var friendList = [Users]()
    
    static let share = UserInfo()
    private init(){
        
    }
}
