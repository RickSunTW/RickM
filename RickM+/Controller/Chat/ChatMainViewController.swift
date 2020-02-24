//
//  ChatMainViewController.swift
//  RickM+
//
//  Created by RickSun on 2020/2/5.
//  Copyright © 2020 RickSun. All rights reserved.
//

import UIKit
import Firebase

class ChatMainViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBAction func SelectNewChatBtnAction(_ sender: UIButton) {
        
        performSegue(withIdentifier: "SelectNewChat", sender: nil)
        
    }

    @IBAction func sadfasfasfg(_ sender: UIButton) {
        
        print("aaaaa")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        observeMessages()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
//        observeUserMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    var chatLog = [Message]()
    var chatMessageDictionary = [String: Message]()
    var toId = String()
//    var seedMessageTime = [String]()
//    var chatSelfImage = [URL]()
    
//    func observeUserMessages() {
//        let db = Firestore.firestore().collection("user-messages").document("\(UserInfo.share.logInUserUid)")
//
//        db.addSnapshotListener { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//            } else {
//                guard let quary = querySnapshot else {
//
//
//                    return
//
//                }
//                for document in quary.documents {
//
//                    print("\(document)")
//                }
//
//            }
//        }
//
//        db.getDocument { (DocumentSnapshot?, <#Error?#>) in
//            <#code#>
//        }
//
//    }
    
    func observeMessages() {
        let db = Firestore.firestore().collection("Message").order(by: "timestamp", descending: false)
        
        
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
//
//                self.chatName.removeAll()
                
                for document in quary.documents {
                    
                    do {
                        
                        document.data()
                        
                        let chat = try document.data(as: Message.self, decoder: Firestore.Decoder())
                        
                        guard var messageDL = chat else {return}
                        
                        if messageDL.formid == UserInfo.share.logInUserUid {
                            for searchFriend in 0...(UserInfo.share.friendList.count - 1) {
                                
                                if messageDL.toid == UserInfo.share.friendList[searchFriend].id {
                                    
                                    messageDL.toName = UserInfo.share.friendList[searchFriend].name
                                    
                                    guard let url = URL(string: UserInfo.share.friendList[searchFriend].photoURL!) else { return }
                                    
                                    messageDL.toPhotoUrl = url
                                    
                                    let format = DateFormatter()
                                    
                                    format.dateFormat = "dd/MM hh:mm a"
                                    
                                    let newdate = NSDate(timeIntervalSince1970: messageDL.timestamp!) as Date
                                    
                                    messageDL.timestampString = format.string(from: newdate)
                                    
                                }
                            }
                        } else if messageDL.toid == UserInfo.share.logInUserUid {
                            for searchFriend in 0...(UserInfo.share.friendList.count - 1) {
                                
                                if messageDL.formid == UserInfo.share.friendList[searchFriend].id {
                                    messageDL.toName = UserInfo.share.friendList[searchFriend].name
                                    
                                    guard let url = URL(string: UserInfo.share.friendList[searchFriend].photoURL!) else { return }
                                    
                                    messageDL.toPhotoUrl = url
                                    
                                    let format = DateFormatter()
                                    
                                    format.dateFormat = "dd/MM hh:mm a"
                                    
                                    let newdate = NSDate(timeIntervalSince1970: messageDL.timestamp!) as Date
                                    
                                    messageDL.timestampString = format.string(from: newdate)
                                    
                                }
                                
                               
                                
                            }
                            
                        }
                        
                        
//                        for searchFriend in 0...(UserInfo.share.friendList.count - 1){
//                            if messageDL.formid == UserInfo.share.logInUserUid {
//
//                                messageDL.toName = UserInfo.share.friendList[searchFriend].name
//
//                                guard let url = URL(string: UserInfo.share.friendList[searchFriend].photoURL!) else { return }
//
//                                messageDL.toPhotoUrl = url
//
//                                let format = DateFormatter()
//
//                                format.dateFormat = "dd/MM hh:mm a"
//
//                                let newdate = NSDate(timeIntervalSince1970: messageDL.timestamp!) as Date
//
//                                messageDL.timestampString = format.string(from: newdate)
//
////                                print("\(messageDL)")
//
//                            } else if messageDL.toid == UserInfo.share.logInUserUid {
//                                messageDL.toName = UserInfo.share.friendList[searchFriend].name
//
//                                guard let url = URL(string: UserInfo.share.friendList[searchFriend].photoURL!) else { return }
//
//                                messageDL.toPhotoUrl = url
//
//                                let format = DateFormatter()
//
//                                format.dateFormat = "dd/MM hh:mm a"
//
//                                let newdate = NSDate(timeIntervalSince1970: messageDL.timestamp!) as Date
//
//                                messageDL.timestampString = format.string(from: newdate)
//                            }
//
//
//                        }
                        
                        //                        print("\(messageDL)")
                        
                        
                        if messageDL.toid == UserInfo.share.logInUserUid {
                            
                            self.toId = messageDL.formid!
                            
                            self.chatMessageDictionary[self.toId] = messageDL
                            
                        }
                        else if messageDL.formid == UserInfo.share.logInUserUid {
                            
                            self.toId = messageDL.toid!
                            
                            self.chatMessageDictionary[self.toId] = messageDL
                            
                        }
                        
                        
                        self.chatLog = Array(self.chatMessageDictionary.values)
                        
//                        print(self.chatLog.count)
                        
//                        if let toId = messageDL.toid {
//
//                            self.chatMessageDictionary[toId] = messageDL
//
//
//                            self.chatLog = Array(self.chatMessageDictionary.values)
//
//                        }
                        
                        DispatchQueue.main.async {
                            
                            self.chatTableView.reloadData()
                            
                        }
                        
                    } catch {
                        
                        print(error)
                        
                    }
                }
            }
        }
    }
    
    func showChatController(user: Users) {
        
        let chatLogControler = ChatLogController(collectionViewLayout: UICollectionViewLayout())
        navigationController?.pushViewController(chatLogControler, animated: true)
        chatLogControler.user = user
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is SelectNewChatController {
            
            let vc = segue.destination as? SelectNewChatController
            
            vc?.chatHandler = { [weak self] (chat) in
                self?.showChatController(user: chat)
                
//                print("\(chat)")
                
            }
        }
    }
}

extension ChatMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatLog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUITableVIewCell", for: indexPath) as? ChatListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.chatListName.text = chatLog[indexPath.row].toName
        cell.chatListLastChat.text = chatLog[indexPath.row].text
        cell.chatListLastDay.text = chatLog[indexPath.row].timestampString
        cell.chatListImage.kf.setImage(with: chatLog[indexPath.row].toPhotoUrl)
        cell.chatListImage.contentMode = .scaleToFill
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let showTheChatName = chatLog[indexPath.row].toName
        

        
        for x in 0...(UserInfo.share.friendList.count - 1){
            if showTheChatName == UserInfo.share.friendList[x].name {
                UserInfo.share.chatRealTimePairUidToFriend = "\(UserInfo.share.friendList[x].id)-\(UserInfo.share.logInUserUid)"
                
                UserInfo.share.chatRealTimePairUidFromMe = "\(UserInfo.share.logInUserUid)-\(UserInfo.share.friendList[x].id)"
                self.showChatController(user: UserInfo.share.friendList[x] )
                
            }
        }
    }
}

