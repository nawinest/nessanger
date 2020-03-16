//
//  ChatLogViewController.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 27/2/2563 BE.
//  Copyright (c) 2563 Nawin Phunsawat. All rights reserved.
//

import UIKit
import Firebase

class ChatLogViewController: UIViewController {
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    var user: UserModel? {
        didSet {
            navigationItem.title = user?.name
            observeMessage()
        }
    }
    
    var messages: [Message] = []
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    lazy var sendButton: UIButton = {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        return sendButton
    }()
    
    lazy var chatInputTextField: UITextField = {
        let chatInputTextField = UITextField()
        chatInputTextField.placeholder = "Enter message..."
        chatInputTextField.autocorrectionType = .no
        chatInputTextField.translatesAutoresizingMaskIntoConstraints = false
        return chatInputTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = .zero
        mainCollectionView.collectionViewLayout = layout
        mainCollectionView.alwaysBounceVertical = true
        mainCollectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.keyboardDismissMode = .interactive
        mainCollectionView.register(UINib(nibName: "ChatCell", bundle: nil), forCellWithReuseIdentifier: "chatCell")
        becomeFirstResponder()
    }

    func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardAnimationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double)!
            containerViewBottomAnchor?.constant = -( keyboardSize.height - self.view.safeAreaInsets.bottom )
            UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = .white
       
        let uploadImage = UIImageView()
        uploadImage.image = UIImage(named: "imagePicker")
        containerView.addSubview(uploadImage)
        uploadImage.isUserInteractionEnabled = true
        uploadImage.translatesAutoresizingMaskIntoConstraints = false
        uploadImage.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        uploadImage.heightAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImage.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadImage)))
        
        sendButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        containerView.addSubview(sendButton)
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -4).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        
        containerView.addSubview(chatInputTextField)
        chatInputTextField.delegate = self
        chatInputTextField.leftAnchor.constraint(equalTo: uploadImage.rightAnchor, constant: 8).isActive = true
        chatInputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8).isActive = true
        chatInputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1).isActive = true
        chatInputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        let seperateLine = UIView()
        seperateLine.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        containerView.addSubview(seperateLine)
        seperateLine.translatesAutoresizingMaskIntoConstraints = false
        seperateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        seperateLine.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        seperateLine.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        seperateLine.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        
        let keyboardAnimationDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double)!
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardAnimationDuration, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func observeMessage() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else { return }
        let userMsgRef = Database.database().reference().child("user_message").child(uid).child(toId)
        userMsgRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observe(.value, with: { (snapShotInside) in
                guard let dictionary = snapShotInside.value as? [String: AnyObject] else {return}
                
                let message = Message(dictionary: dictionary)
                
                self.messages.append(message)
                let lastIdx = IndexPath(row: self.messages.count - 1, section: 0)
                DispatchQueue.main.async {
                    self.mainCollectionView.reloadData()
                    self.mainCollectionView.scrollToItem(at: lastIdx, at: .top, animated: true)
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
   
    func setupContainerInputView() {
        
    }
    
    @objc func handleSendMessage() {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id
        let fromId = Auth.auth().currentUser?.uid
        let timeStamp = Int(Date().timeIntervalSince1970)
        let value = [
            "text": chatInputTextField.text!,
            "toId": toId!, "fromId": fromId!,
            "timeStamp": timeStamp] as [String : Any]
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
}


extension ChatLogViewController: UITextFieldDelegate {
    
}


extension ChatLogViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "chatCell", for: indexPath) as! ChatCell
        if let text = self.messages[indexPath.row].text {
            cell.titleLabel.text = text
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
        } else {
            cell.titleLabel.text = nil
        }
        
        setupCell(cell: cell, message: self.messages[indexPath.row])
        
        return cell
    }
    
    func setupCell(cell: ChatCell, message: Message) {
        if let urlImagePath = user?.profileImageUrl {
            cell.profileImageView.loadImageFromCache(urlImageString: urlImagePath)
        } else {
            cell.profileImageView.image = nil
        }
        
       
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = ChatCell.blue
            cell.titleLabel.textColor = .white
            cell.profileImageView.isHidden = true
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
        } else {
            cell.profileImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.titleLabel.textColor = .black
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
        }
        
        if let msgImageUrl = message.imageUrl {
            cell.messageImageView.loadImageFromCache(urlImageString: msgImageUrl)
            cell.bubbleView.backgroundColor = .clear
        } else {
            cell.messageImageView.image = nil
        }
               
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let text = self.messages[indexPath.row].text {
            height = estimateFrameForText(text: text).height + 20
        } else if let imageWidth = self.messages[indexPath.row].msgImageWidth?.floatValue,
                let imageHeight = self.messages[indexPath.row].msgImageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        return CGSize(width: self.mainCollectionView.frame.width, height: height)
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0)], context: nil)
    }
    
    
    
}
