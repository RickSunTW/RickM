//
//  UserProfileManager.swift
//  RickM+
//
//  Created by RickSun on 2020/2/14.
//  Copyright © 2020 RickSun. All rights reserved.
//

import Foundation
import Firebase
import Kingfisher
//import FirebaseFirestoreSwift

protocol UserProfileManagerDelegate: AnyObject {
    
    func manager(_ manager: UserProfileManager, didgetUserData: Users)
    
    func manager(_ manager: UserProfileManager, didFailWith error: Error)
    
}

class UserProfileManager {
    
    weak var delegate: UserProfileManagerDelegate?
    
    let db = Firestore.firestore()
    
    func getUserData(id: String) {
        
        db.collection("Users").whereField("id", isEqualTo: id).getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let quary = querySnapshot else {
                    
                    return
                    
                }
                
                for document in quary.documents {
                    
                    do {
                        
                        let user = try document.data(as: Users.self, decoder: Firestore.Decoder())
                        
                        guard let loadingFriends = user?.friends else {
                            return
                        }
                        
                        UserInfo.share.saveFriends = []
                        UserInfo.share.colleagueFriendsName = []
                        UserInfo.share.colleagueFriendsStatus = []
                        UserInfo.share.colleagueFriendsPhoto = []
                        
                        UserInfo.share.saveFriends = loadingFriends
                        
                        guard let userInfo = user else {return}
                        
                        self.delegate?.manager(self, didgetUserData: userInfo)
                        
                        
                    } catch {
                        
                        print(error)
                        
                    }
                }
            }
        }
    }
    
    func getFriends(friendsemail: [String]) {
        
        for email in friendsemail {
            
            db.collection("Users").whereField("email", isEqualTo: email).getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    
                    print("Error getting documents: \(err)")
                    
                } else {
                    
                    guard let quary = querySnapshot else {
                        
                        return
                        
                    }
                    
                    for document in quary.documents {
                        
                        do {
                            
                            let friendInfo = try document.data(as: Users.self, decoder: Firestore.Decoder())
                            
                            guard let userInfo = friendInfo else {return}
                            guard let userPhotoURL = userInfo.photoURL else {return}
                            guard let url = URL(string: userPhotoURL)else {return}
                            let resource = ImageResource(downloadURL: url)
                            

                            
                            
                            if userInfo.colleague {
                                
                                UserInfo.share.colleagueFriendsName.append(userInfo.name)
                                UserInfo.share.colleagueFriendsStatus.append(userInfo.status)
                                UserInfo.share.colleagueFriendsPhoto.append(resource)
                                
                            } else {
                                UserInfo.share.normalFriendsName.append(userInfo.name)
                                UserInfo.share.normalFriendsStatus.append(userInfo.status)
                                UserInfo.share.normalFriendsPhoto.append(resource)
                                
                            }
                            
//                            print("\(UserInfo.share.colleagueFriendsName)")
//                            print("\(UserInfo.share.colleagueFriendsStatus)")
//                            print("\(UserInfo.share.colleagueFriendsPhoto)")
                            
                            
//                            print("\(UserInfo.share.normalFriendsName)")
//                            print("\(UserInfo.share.normalFriendsStatus)")
//                            print("\(UserInfo.share.normalFriendsPhoto)")
                            
                            
                            
                        } catch {
                            
                            print(error)
                            
                        }
                    }
                }
            }
        }
    }
}
