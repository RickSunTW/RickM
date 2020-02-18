//
//  ChangeNamwViewController.swift
//  RickM+
//
//  Created by RickSun on 2020/2/10.
//  Copyright © 2020 RickSun. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseFirestoreSwift

class ChangeNamwViewController: UIViewController {
    
    
    @IBOutlet weak var setNameTextField: UITextField!
    
    @IBAction func setNameBtnAction(_ sender: UIButton) {
    
        let db = Firestore.firestore()
     
        guard let text = setNameTextField.text else { return }
            db.collection("Users").document("\(UserInfo.share.logInUserUid)").setData([
                "name":"\(text)",
            ], merge: true)
        
        navigationController?.popViewController(animated: true)

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
