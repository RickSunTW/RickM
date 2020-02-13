//
//  SelfInformationViewController.swift
//  RickM+
//
//  Created by RickSun on 2020/2/10.
//  Copyright © 2020 RickSun. All rights reserved.
//

import UIKit
import Firebase


class SelfInformationViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var selfImageBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLable: UILabel!
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
        UpdateSelfData()
    }
    
    @IBAction func changeStatusAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ChangeStatus", sender: nil)
        DeleteSelfData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readUsers(id: "\(UserUid.share.logInUserUid)")
        
        // Do any additional setup after loading the view.
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
        metaData.contentType = "image/png"

        storageRef.putData(uploadData!, metadata: metaData) { (metadata, error) in
            if error != nil {
                print("error")
                return
            } else {
                storageRef.downloadURL { (url, error) in
                    url
                }
            }
        }
    }
    
    
    

func readUsers(id: String){
    db.collection("Users").whereField("id", isEqualTo: id).getDocuments(){ (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            guard let quary = querySnapshot else {return }
            
            for document in quary.documents {
                let documentdata = document.data()
                print("\(document.documentID) => \(document.data())")
            }
        }
    }
}
func UpdateSelfData() {
    
    db.collection("Users").document("\(UserUid.share.logInUserUid)").setData([
        "name":"內湖洲子魚",
        "心情":"尚可"
    ], merge: true)
    
}

func DeleteSelfData(){
    db.collection("Users").document("\(UserUid.share.logInUserUid)").updateData(["心情":FieldValue.delete()])
    
    
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
