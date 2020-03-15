//
//  SignInViewController.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 26/2/2563 BE.
//  Copyright (c) 2563 Nawin Phunsawat. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    let inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "person")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImage)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    let nameTextField: UITextField = {
        let textF = UITextField()
        textF.placeholder = "Name"
        textF.translatesAutoresizingMaskIntoConstraints = false
        return textF
    }()
    
    lazy var loginSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Sign In", "Sign Up"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleSegmentedControlChange), for: .valueChanged)
        return sc
    }()
    
    let emailTextField: UITextField = {
        let textF = UITextField()
        textF.placeholder = "Email"
        textF.translatesAutoresizingMaskIntoConstraints = false
        return textF
    }()
    
    let passwordTextField: UITextField = {
        let textF = UITextField()
        textF.placeholder = "Password"
        textF.translatesAutoresizingMaskIntoConstraints = false
        textF.isSecureTextEntry = true
        return textF
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(r: 61, g: 91, b: 151)
        view.addSubview(inputContainer)
        view.addSubview(loginRegisterButton)
        self.setupInputContainterView()
        self.setupLoginRegisterButton()
        self.setupInputTextField()
        self.setupProfileImageAndSegmentedControl()
    }
    
    var inputContainerHeightAnchor: NSLayoutConstraint?
    
    func setupInputContainterView() {
        inputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerHeightAnchor = inputContainer.heightAnchor.constraint(equalToConstant: 150)
        inputContainerHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: 16).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProfileImageAndSegmentedControl() {
        view.addSubview(loginSegmentedControl)
        loginSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginSegmentedControl.bottomAnchor.constraint(equalTo: inputContainer.topAnchor, constant: -12.0).isActive = true
        loginSegmentedControl.widthAnchor.constraint(equalTo: inputContainer.widthAnchor, multiplier: 1/2).isActive = true
        loginSegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(profileImageView)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    func setupInputTextField() {
        inputContainer.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 12).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: inputContainer.rightAnchor, constant: -12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: 0).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        inputContainer.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 12).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: inputContainer.rightAnchor, constant: -12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 0).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        inputContainer.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 12).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: inputContainer.rightAnchor, constant: -12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 0).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    @objc func handleLoginRegister() {
        if loginSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = self.emailTextField.text,
            let password = self.passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("sorry, we can't login user :", error)
                return
            }

            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func handleRegister() {
        guard let name = nameTextField.text,
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("sorry, we can't create user :", error)
                return
            }
            guard let uid = authResult?.user.uid else { return }
            guard let profileImage = self.profileImageView.image else {return}
            guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else { return }
            let filename = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                
                if let err = err {
                    print("Failed to upload profile image:", err)
                    return
                }
                
                storageRef.downloadURL(completion: { (downloadURL, err) in
                    if let err = err {
                        print("Failed to fetch downloadURL:", err)
                        return
                    }
                    
                    guard let profileImageUrl = downloadURL?.absoluteString else { return }
                    
                    print("Successfully uploaded profile image:", profileImageUrl)
                    
                    let dictionaryValues = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                    let values = [uid: dictionaryValues]
                    
                    //successful sign up
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print("Failed to save user info into db:", err)
                            return
                        }
                        print("Successfully saved user info to db")
                        self.dismiss(animated: true, completion: nil)
                    })
                })
            })
        }
    }
    
    @objc func handleSegmentedControlChange() {
        let title = loginSegmentedControl.titleForSegment(at: loginSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        inputContainerHeightAnchor?.constant = loginSegmentedControl.selectedSegmentIndex == 0 ? 100: 150
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: loginSegmentedControl.selectedSegmentIndex == 0 ? 0: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: loginSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: loginSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
}


extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
