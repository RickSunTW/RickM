//
//  ChangeNamwViewController.swift
//  RickM+
//
//  Created by RickSun on 2020/2/10.
//  Copyright © 2020 RickSun. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ChangeNamwViewController: UIViewController {
    
    @IBOutlet weak var setNameTextField: UITextField!
    
    @IBAction func setNameBtnAction(_ sender: UIButton) {
        
        let db = Firestore.firestore()
        func UpdateSelfData() {
            
            db.collection("Users").document("\(UserUid.share.logInUserUid)").setData([
                "name":"\(setNameTextField)",
            ], merge: true)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
