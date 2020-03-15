//
//  SignIn+handler.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 26/2/2563 BE.
//  Copyright © 2563 Nawin Phunsawat. All rights reserved.
//

import UIKit

extension SignInViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleSelectImage() {
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
            self.profileImageView.image = selected
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
