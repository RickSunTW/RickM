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
import FirebaseFirestoreSwift

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    var user: Users? {
        didSet {
            navigationItem.title = user?.name
        }
        
    }
    
    var chatLog = [Message]()
    let cellId = "cellId"
    
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
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupInputComponents()
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    func observeMessages() {
            let db = Firestore.firestore().collection("Message").whereField("formid", isEqualTo: UserInfo.share.logInUserUid).order(by: "timestamp", descending: false)
            
            
    //        .whereField("formid", isEqualTo: UserInfo.share.logInUserUid)
    //        .order(by: "timestamp", descending: false)
            
            db.addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    
                    print("Error getting documents: \(error)")
                    
                } else {
                    
                    guard let quary = querySnapshot else {
                        
                        return
                        
                    }
                    
                    self.chatLog.removeAll()

                    
                    for document in quary.documents {
                        
                        do {
                            
                            document.data()
                            
                            let chat = try document.data(as: Message.self, decoder: Firestore.Decoder())
                            
                            guard var messageDL = chat else {return}
                            
                            for searchFriend in 0...(UserInfo.share.friendList.count - 1){
                                if messageDL.toid == UserInfo.share.friendList[searchFriend].id {
                                    
                                    messageDL.toName = UserInfo.share.friendList[searchFriend].name
                                    
                                    guard let url = URL(string: UserInfo.share.friendList[searchFriend].photoURL!) else { return }
                                    
                                    messageDL.toPhotoUrl = url
                                    
                                    let format = DateFormatter()
                                    
                                    format.dateFormat = "dd/MM hh:mm a"
                                    
                                    let newdate = NSDate(timeIntervalSince1970: messageDL.timestamp!) as Date
                                    
                                    messageDL.timestampString = format.string(from: newdate)
                                    
    //                                print("\(messageDL)")
                                    
                                }
                                
                            }
                            
    //                        print("\(messageDL)")
                            

                            
                            DispatchQueue.main.async {
                                
                                self.collectionView.reloadData()
                                
                            }
                            
                        } catch {
                            
                            print(error)
                            
                        }
                    }
                }
            }
        }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = UIColor.blue
        
        return cell
        
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
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
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
    
    @objc func handleSend() {
        
        let db = Firestore.firestore()
        let timeStamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        
//        var id = String()
        
//        let chatUid = UUID().uuidString
        
        db.collection("Message").document().setData([
            
//            id  = DocumentID
            "text": "\(inputTextField.text!)",
            "toid": "\(user!.id)",
            "formid": "\(UserInfo.share.logInUserUid)",
            "timestamp": timeStamp,
            
            ])
        { (error) in
            if let error = error {
                print(error)
            }

        }
        
//        db.collection("user-messages").document("\(UserInfo.share.logInUserUid)").setData([
//            "\(chatUid)": "1",
//            ], merge: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        handleSend()
        return true
    }
    
}


extension ChatLogController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.height, height: 80)
    }
    
}
