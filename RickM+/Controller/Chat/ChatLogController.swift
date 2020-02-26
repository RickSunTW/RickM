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


class ChatLogController: UICollectionViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: Users? {
        didSet {
            navigationItem.title = user?.name
            
            let showTheChatName = user?.name
            
            for x in 0...(UserInfo.share.friendList.count - 1){
                if showTheChatName == UserInfo.share.friendList[x].name {
                    UserInfo.share.chatRealTimePairUidToFriend = "\(UserInfo.share.friendList[x].id)-\(UserInfo.share.logInUserUid)"
                    
                    UserInfo.share.chatRealTimePairUidFromMe = "\(UserInfo.share.logInUserUid)-\(UserInfo.share.friendList[x].id)"
                  
                    
                }
            }
            
            observeMessageChat()
            
        }
        
    }
    
    var chatLog = [Message]()
    let cellId = "cellId"
    var chatToPhotoUrl = String()
    
    lazy var inputTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.backgroundColor = .clear
        
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.white
        
        collectionView.alwaysBounceVertical = true
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: -12, right: 0)
        
//        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        
        collectionView.register(ChatMessageCellCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 100, height: 100)
        
        layout.scrollDirection = .vertical
        
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        collectionView.keyboardDismissMode = .interactive
        
//        setupInputComponents()
        
//        setupKeyboardObservers()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        //avoid memory leak
    }
    
    lazy var inputContainerView: UIView = {
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(systemName: "photo")
        uploadImageView.tintColor = .darkGray
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        containerView.addSubview(uploadImageView)
        
//        x,y,w,h
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true


        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
//        x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        containerView.addSubview(inputTextField)
        
//        x,y,w,h
        inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant:  8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.darkGray
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
//        x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
    }()
    
    
    @objc func handleUploadTap() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = .fullScreen
        present(imagePickerController, animated: true, completion: nil)
        
//        show(imagePickerController, sender: Any?.self)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFormPicker: UIImage?
        
        if let editedImage = info[.editedImage]  as? UIImage {
            selectedImageFormPicker = editedImage
            
        } else if let pickedImage = info[.originalImage] as? UIImage {
            selectedImageFormPicker = pickedImage
           
        }
        
        dismiss(animated: true, completion: nil)
        
        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("message_images").child(imageName)
        
        let uploadData = selectedImageFormPicker?.pngData()
        
        let metaData = StorageMetadata()
        
        metaData.contentType = "image/jpg"
        
        storageRef.putData(uploadData!, metadata: metaData) { (metadata, error) in
            if error != nil {
                print("error")
                return
            }
            else {
                storageRef.downloadURL { (url, error) in
                    guard let photoURL = url?.absoluteURL else { return }
                    self.seedMessageWithImageUrl(imageUrl: photoURL)
//                    print(photoURL)
//                    let db = Firestore.firestore()
//                    db.collection("Users").document("\(UserInfo.share.logInUserUid)").setData([
//                        "photoURL":"\(photoURL)",
//                    ], merge: true)

                }
            }
        }
    }
    
    private func seedMessageWithImageUrl(imageUrl: URL) {
            
            let db = Firestore.firestore()
            let timeStamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
            
            
            db.collection("Message").document().setData([
                
    //            id  = DocumentID
                "imageUrl": "\(imageUrl)",
                "toid": "\(user!.id)",
                "formid": "\(UserInfo.share.logInUserUid)",
                "chatUid": "\(UserInfo.share.logInUserUid)-\(user!.id)",
                "timestamp": timeStamp,
                
                ])
            { (error) in
                if let error = error {
                    print(error)
                }

            }
            
            self.inputTextField.text = nil
            
    //        db.collection("user-messages").document("\(UserInfo.share.logInUserUid)").setData([
    //            "\(chatUid)": "1",
    //            ], merge: true)
            
        }
    
    override var inputAccessoryView: UIView? {
        get {
        
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,selector: #selector(handleKeyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardWillShow(notification: NSNotification){
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if keyboardFrame.height == 343 {
                
                 containerViewBottomAnchor?.constant = -keyboardFrame.height
            } else {
                
                containerViewBottomAnchor?.constant = -343
                
            }
            
//            containerViewBottomAnchor?.constant = -keyboardFrame.height
//            print(keyboardFrame)
        }
        if let keyBoardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            
            UIView.animate(withDuration: keyBoardDuration) {
                
                self.view.layoutIfNeeded()
                
            }
        }
        
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        
        if let keyBoardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            
            UIView.animate(withDuration: keyBoardDuration) {
                
                self.view.layoutIfNeeded()
                
            }
        }
            containerViewBottomAnchor?.constant = 0
        
    }
    
    func observeMessageChat() {
            let db = Firestore.firestore().collection("Message").order(by: "timestamp", descending: false)
            
            
    //        .whereField("chatUid", isEqualTo: UserInfo.share.chatRealTimePairUidToFriend)
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
                            
                            if messageDL.chatUid == "\(UserInfo.share.chatRealTimePairUidToFriend)" {
                                
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
                            
                            if messageDL.chatUid == UserInfo.share.chatRealTimePairUidToFriend {
                                
                                self.chatLog.append(messageDL)
                                
                            }
                            else if messageDL.chatUid == UserInfo.share.chatRealTimePairUidFromMe {
                                
                                self.chatLog.append(messageDL)
                                
                            }
                            
//                            print("\(messageDL)")
//                            print("\(self.chatLog.count)")
                            
                            
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
        
        return chatLog.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCellCollectionViewCell
        
        cell.textView.text = chatLog[indexPath.row].text
        
        if let text = chatLog[indexPath.row].text {
            
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 20
            
        }
        
        if let messageImageurl = chatLog[indexPath.row].imageUrl {
            
            cell.messageImageView.kf.setImage(with: messageImageurl)
            
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
            
        } else {
            
            cell.messageImageView.isHidden = true
            
        }
        
        
        
        cell.profileImageView.kf.setImage(with: chatLog[indexPath.row].toPhotoUrl)
        
        if UserInfo.share.logInUserUid == chatLog[indexPath.row].formid {
            
            cell.bubbleView.backgroundColor = UIColor(red: 0/255, green: 137/255, blue: 249/255, alpha: 1)
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
            
        } else {
            
            cell.bubbleView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            cell.textView.textColor = .black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            
        }
    
        return cell
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
//        print("ya")
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//           self.view.endEditing(true)
//       }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        //x,y,w,h
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true

        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
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
            "chatUid": "\(UserInfo.share.logInUserUid)-\(user!.id)",
            "timestamp": timeStamp,
            
            ])
        { (error) in
            if let error = error {
                print(error)
            }

        }
        
        self.inputTextField.text = nil
        
//        db.collection("user-messages").document("\(UserInfo.share.logInUserUid)").setData([
//            "\(chatUid)": "1",
//            ], merge: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        handleSend()
        return true
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 800)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)], context: nil)
        
    }
    
}


extension ChatLogController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if let text = chatLog[indexPath.row].text {
            
            height = estimateFrameForText(text: text).height + 20
            
        }
        
        let width = UIScreen.main.bounds.width
        
        return CGSize(width: width, height: height)
    }
    
    
}
