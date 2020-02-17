//
//  SelfInformationViewController.swift
//  RickM+
//
//  Created by RickSun on 2020/2/10.
//  Copyright © 2020 RickSun. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import Kingfisher

class SelfInformationViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var selfImageBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var mIDLabel: UILabel!
    
    
    @IBAction func setSelfImageAction(_ sender: UIButton) {
        
        let setImageController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "開啟相機拍照", style: .default) { (_) in
            
            self.camera()
            //info.plist 修改Localization native development region -> $(DEVELOPMENT_LANGUAGE)
        }
        let libraryAction = UIAlertAction(title: "從相簿中選擇", style: .default) { (_) in
            self.photopicker()
        }
        let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { (_) in
            sender.setImage(UIImage(named: "photo"), for: .normal)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        setImageController.addAction(cameraAction)
        
        setImageController.addAction(libraryAction)
        
        setImageController.addAction(deleteAction)
        
        setImageController.addAction(cancelAction)
        
        present(setImageController, animated: true, completion: nil)
        
    }
    
    @IBAction func changeNameAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "ChangeName", sender: nil)
        
    }
    
    @IBAction func changeStatusAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "ChangeStatus", sender: nil)
        
    }
    
    var userProfileManager = UserProfileManager()
    
//    var userProfileData = [Users]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileManager.delegate = self
        
        //        userProfileManager.getUserData(id: "\(UserUid.share.logInUserUid)")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        userProfileManager.getUserData(id: "\(UserUid.share.logInUserUid)")
        
    }
    
    let db = Firestore.firestore()
    
    func photopicker(){
        
        let photoController = UIImagePickerController()
        
        photoController.delegate = self
        
        photoController.sourceType = .photoLibrary
        
        present(photoController, animated: true, completion: nil)
        
    }
    func camera(){
        
        let cameraController = UIImagePickerController()
        
        cameraController.delegate = self
        
        cameraController.sourceType = .camera
        
        present(cameraController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFormPicker: UIImage?
        
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImageFormPicker = pickedImage
            selfImageBtn.setImage(selectedImageFormPicker, for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
        
        let uniqueString = UUID().uuidString
        
        let storageRef = Storage.storage().reference().child("UserProfilePhoto").child("\(uniqueString).jpg")
        
        let uploadData = selectedImageFormPicker?.pngData()
        
        let metaData = StorageMetadata()
        
        metaData.contentType = "image/jpg"
        
        storageRef.putData(uploadData!, metadata: metaData) { (metadata, error) in
            if error != nil {
                print("error")
                return
            }
            else { storageRef.downloadURL { (url, error) in
                guard let photoURL = url?.absoluteURL else { return }
                self.db.collection("Users").document("\(UserUid.share.logInUserUid)").setData([
                    "photoURL":"\(photoURL)",
                ], merge: true)
                
                }
            }
        }
    }
}

//func UpdateSelfData() {
//
//    db.collection("Users").document("\(UserUid.share.logInUserUid)").setData([
//        "name":"內湖洲子魚",
//        "心情":"尚可"
//    ], merge: true)
//
//}
//
//func DeleteSelfData(){
//
//    db.collection("Users").document("\(UserUid.share.logInUserUid)").updateData(["心情":FieldValue.delete()])
//
//}
//
//}

extension SelfInformationViewController: UserProfileManagerDelegate {
    
    func manager(_ manager: UserProfileManager, didgetUserData: Users) {
        
        DispatchQueue.main.async {
            
            self.nameLabel.text = didgetUserData.name
            
            self.statusLabel.text = didgetUserData.status
            
            self.phoneNumberLabel.text = didgetUserData.phoneNumber
            
            self.mIDLabel.text = didgetUserData.mID
            
            if didgetUserData.photoURL != nil {
                guard let url = URL(string: didgetUserData.photoURL!) else {
                    return print("URL Error")
                }
                let resource = ImageResource(downloadURL: url)
                
                self.selfImageBtn.kf.setImage(with: resource, for: .normal)
            }
//            else if didgetUserData.photoURL == nil {
//            
//                self.selfImageBtn.setImage(UIImage(named: "photo"), for: .normal)
//
//        }
        
    }
    }
    
    func manager(_ manager: UserProfileManager, didFailWith error: Error) {
        
        print(error.localizedDescription)
        
    }
    
}
