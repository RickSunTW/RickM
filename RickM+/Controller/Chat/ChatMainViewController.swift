//
//  ChatMainViewController.swift
//  RickM+
//
//  Created by RickSun on 2020/2/5.
//  Copyright © 2020 RickSun. All rights reserved.
//

import UIKit

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
        
        // Do any additional setup after loading the view.
    }
    
//    func handleNewMessage() {
//
//
//    }
    
    
    
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUITableVIewCell", for: indexPath) as? ChatListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.chatListName.text = "Hank"
        
        return cell
        
    }

}
