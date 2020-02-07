//
//  LogInViewController.swift
//  RickM+
//
//  Created by RickSun on 2020/2/7.
//  Copyright © 2020 RickSun. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var accountTtextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func signUpBtn(_ sender: UIButton) {
    }
    @IBAction func signInBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "SignIn", sender: nil)
        
        
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
