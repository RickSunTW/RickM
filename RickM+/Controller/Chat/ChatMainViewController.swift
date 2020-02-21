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
    
    var chatLog = [Message]()
    var seedMessageTime = [String]()
    var chatName = [String]()
    var chatSelfImage = [URL]()
    
    func observeMessages() {
        let db = Firestore.firestore().collection("Message")
        
        db.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                
                print("Error getting documents: \(error)")
                
            } else {
                
                guard let quary = querySnapshot else {
                    
                    return
                    
                }
                
                self.chatLog.removeAll()
                
                self.chatName.removeAll()
                
                for document in quary.documents {
                    
                    do {
                        
                        document.data()
                        
                        let chat = try document.data(as: Message.self, decoder: Firestore.Decoder())
                        
                        guard let messageDL = chat else {return}
                        
                        self.chatLog.append(messageDL)
                        
//                        let date = Date()
                        
                        let format = DateFormatter()
                        
//                        let year = DateFormatter()
                        
                        format.dateFormat = "dd/MM hh:mm"
                        
                        let newdate = NSDate(timeIntervalSince1970: messageDL.timestamp!) as Date
                        
                        let timeArray = format.string(from: newdate)
                        
                        self.seedMessageTime.append(timeArray)
                        
                        print(format.string(from: newdate))
                        
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is SelectNewChatController {
            
            let vc = segue.destination as? SelectNewChatController
            
            vc?.chatHandler = { [weak self] (chat) in
                self?.showChatController(user: chat)
                
                print("\(chat)")
                
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
        
        if let toId = chatLog[indexPath.row].toid {
            
            let db = Firestore.firestore()
            
            db.collection("Users").whereField("id", isEqualTo: toId).getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    guard let quary = querySnapshot else {
                        
                        return
                        
                    }
                    
                    for document in quary.documents {
                        
                        do {
                            
                            let user = try document.data(as: Users.self, decoder: Firestore.Decoder())
                            guard let url = URL(string: (user?.photoURL)!) else {return}
                            
                            self.chatName.append(user!.name)
                            self.chatSelfImage.append(url)
                            
                        } catch {
                            
                            print(error)
                            
                        }
                    }
                    
                }
                
                DispatchQueue.main.async {
                    
                    cell.chatListName.text = self.chatName[indexPath.row]
                    cell.chatListImage.kf.setImage(with: self.chatSelfImage[indexPath.row])
                    cell.chatListImage.contentMode = .scaleToFill
                }
                
            }
            
        }
        
        cell.chatListLastChat.text = chatLog[indexPath.row].text
        cell.chatListLastDay.text = seedMessageTime[indexPath.row]
        
        return cell
        
    }
    
}
