//
//  ChatLogController.swift
//  RickM+
//
//  Created by RickSun on 2020/2/19.
//  Copyright © 2020 RickSun. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    var user: Users? {
        didSet {
            navigationItem.title = user?.name
        }
        
    }
    
    lazy var inputTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        collectionView.backgroundColor = UIColor.white
        
        setupInputComponents()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       }
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.lightGray
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        //x,y,w,h
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handlesend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
//        let inputTextField = UITextField()
//        inputTextField.placeholder = "Enter message..."
//        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(inputTextField)
        
        //x,y,w,h
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant:  8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.darkGray
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
           separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
     

        
    }
    
    @objc func handlesend() {
        
        let db = Firestore.firestore()
        db.collection("Message").document().setData([
            "text": "\(inputTextField.text!)",
            ])
        { (error) in
            if let error = error {
                print(error)
            }

        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        handlesend()
        return true
    }
    
}
