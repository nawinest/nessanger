//
//  Chatlog+Handler.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 13/3/2563 BE.
//  Copyright © 2563 Nawin Phunsawat. All rights reserved.
//
import UIKit
import Firebase

extension ChatLogViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleUploadImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let original = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
            selectedImage = original
        }
        
        if let selected = selectedImage {
            uploadToFireStoreUsingImage(selected: selected)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    public func uploadToFireStoreUsingImage(selected: UIImage) {
        guard let uploadData = selected.jpegData(compressionQuality: 0.3) else { return }
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("message-images").child(imageName)
        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
            
            if let err = err {
                print("Failed to upload message image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to fetch downloadURL:", err)
                    return
                }
                
                guard let messageImageUrl = downloadURL?.absoluteString else { return }
                
                print("Successfully uploaded message image:", messageImageUrl)
                self.sendMessageWithImage(messageImageUrl, image: selected)
                
            })
        })
    }
    
    private func sendMessageWithImage(_ imageUrl: String, image: UIImage) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id
        let fromId = Auth.auth().currentUser?.uid
        let timeStamp = Int(Date().timeIntervalSince1970)
        let value = [
            "toId": toId!,
            "fromId": fromId!,
            "timeStamp": timeStamp,
            "imageUrl": imageUrl,
            "msgImageWidth": image.size.width,
            "msgImageHeight": image.size.height
            ] as [String : Any]
        childRef.updateChildValues(value) { (error, ref) in
            if error != nil {
                return
            }
            
            let messageRef = Database.database().reference().child("user_message").child(fromId!).child(toId!)
            let messageId = childRef.key
            messageRef.updateChildValues(["\(messageId!)": 1])
            
            let recipantRef = Database.database().reference().child("user_message").child(toId!).child(fromId!)
            recipantRef.updateChildValues(["\(messageId!)": 1])
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
