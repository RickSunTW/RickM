//
//  LogInViewController.swift
//  RickM+
//
//  Created by RickSun on 2020/2/7.
//  Copyright © 2020 RickSun. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var accountTtextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func signUpBtn(_ sender: UIButton) {
        if accountTtextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: accountTtextField.text!, password: passwordTextField.text!) { (user, error) in
                if error == nil {
                    print("You have successfully signed up")
                    let alertController = UIAlertController(title: "親愛的用戶您好", message: "註冊成功", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    if let userUid = Auth.auth().currentUser?.uid {
                        UserUid.share.logInUserUid = userUid
                        self.addUserData()
                    }
                    
                    
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
        }
        
    }
    @IBAction func signInBtn(_ sender: UIButton) {
        if self.accountTtextField.text == "" || self.passwordTextField.text == "" {
            let alertController = UIAlertController(title: "錯誤", message: "請輸入帳號與密碼", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().signIn(withEmail: accountTtextField.text!, password: passwordTextField.text!) { (user, error) in
                if error == nil {
                    //                    self.performSegue(withIdentifier: "SignIn", sender: nil)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
                    
                    vc?.modalPresentationStyle = .fullScreen
                    
                    self.present(vc!, animated: true, completion: nil)
                    if let userUid = Auth.auth().currentUser?.uid {
                        UserUid.share.logInUserUid = userUid
                    }
                    
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
        }
        //        performSegue(withIdentifier: "SignIn", sender: nil)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func addUserData() {
        let db = Firestore.firestore()
        db.collection("Users").document("\(UserUid.share.logInUserUid)").setData([
            "email": "\(accountTtextField.text!)",
            "friends": ["rick@gmail.com", "violat3049@gmail.com"],
            "id": "\(UserUid.share.logInUserUid)",
            "mID": "Lisa520",
            "name": "Lisa🐑",
            "phoneNumber": "+886928666123",
            "status": "魔力寶貝很好玩"
            ])
        { (error) in
            if let error = error {
                print(error)
            }

        }

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
