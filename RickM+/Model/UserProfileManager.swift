//
//  UserProfileManager.swift
//  RickM+
//
//  Created by RickSun on 2020/2/14.
//  Copyright © 2020 RickSun. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol UserProfileManagerDelegate: AnyObject {
    
    func manager(_ manager: UserProfileManager, didgetUserData: Users)
    
    func manager(_ manager: UserProfileManager, didFailWith error: Error)
    
}

class UserProfileManager {
    
    weak var delegate: UserProfileManagerDelegate?
    
//    var fireUploadDic: [String:Any]?
    
    func getUserData(id: String) {
        
        let db = Firestore.firestore()
        
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
                        
                        
                        self.delegate?.manager(self, didgetUserData: user!)
//                        if let fireUploadDic = user?.photoURL as? [String: Any] {
//
//                        }
                        
                    } catch {
                        
                        print(error)
                        
                    }
                }
            }
        }
    }
}
