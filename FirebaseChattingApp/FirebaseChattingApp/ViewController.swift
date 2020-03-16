//
//  ViewController.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 26/2/2563 BE.
//  Copyright © 2563 Nawin Phunsawat. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameProfileLabel: UILabel!
    @IBOutlet weak var decription: UILabel!
    @IBOutlet weak var viewTableWrapper: UIView!
    @IBOutlet weak var viewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.mainTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "message")
        let image = UIImage(named: "outline_chat")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkIsUserLoggedIn()
        self.observeUserMessage()
    }
   
    var messages: [Message] = []
    var messagesList: [String:Message] = [:]
    
    func observeUserMessage() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("user_message").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child("user_message").child(uid).child(userId).observe(.childAdded, with: { (snap) in
                let messageId = snap.key
                self.fetchMessageByMessageId(messageId: messageId)
            }) { (error) in
                print(error)
            }
        }) { (error) in
            print(error)
        }
    }
    
    private func fetchMessageByMessageId(messageId: String) {
        let messageRef = Database.database().reference().child("messages").child(messageId)
        messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                if let toId = message.toId {
                    self.messagesList[toId] = message
                    self.messages = Array(self.messagesList.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                    return message1.timstamp!.intValue > message2.timstamp!.intValue
                })
            }
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
                }
            }
        })
    }
    
    func checkIsUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot.value ?? "")
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                let user = UserModel(id: snapshot.key, email: (dictionary["email"] as! String), name: (dictionary["name"] as! String), profileImageUrl: (dictionary["profileImageUrl"] as! String))
                self.setupProfileUser(user: user)
            }) { (err) in
                print("Failed to fetch user:", err)
            }
        }
    }
    
    func setupView() {
        self.profileImage.layer.cornerRadius = 8
        self.viewTableWrapper.roundCorners(corners: [.topLeft, .topRight], radius: 16.0)
        self.profileImage.layer.masksToBounds = true
        self.viewTableWrapper.clipsToBounds = true
        self.viewContainer.backgroundColor = UIColor.init(r: 23, g: 44, b: 87)
    }
    
    func setupProfileUser(user: UserModel) {
        self.messagesList.removeAll()
        self.messages.removeAll()
        self.mainTableView.reloadData()
        if let urlImage = user.profileImageUrl {
            self.profileImage.loadImageFromCache(urlImageString: urlImage)
            self.nameProfileLabel.text = user.name ?? ""
        }
        
        
//        let titleView = UIView()
//        let profileImageView = UIImageView()
//        if let urlImage = user.profileImageUrl {
//            profileImageView.loadImageFromCache(urlImageString: urlImage)
//        }
//
//        let containerView = UIView()
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        titleView.addSubview(containerView)
//
//        containerView.addSubview(profileImageView)
//        profileImageView.translatesAutoresizingMaskIntoConstraints = false
//        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
//        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        profileImageView.layer.cornerRadius = 20
//        profileImageView.contentMode = .scaleAspectFill
//        profileImageView.clipsToBounds = true
//
//        let nameLabel = UILabel()
//        nameLabel.text = user.name ?? ""
//        containerView.addSubview(nameLabel)
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 4).isActive = true
//        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -4).isActive = true
//        nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//
//        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
//        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
//
//        self.navigationItem.titleView = titleView
        
    }
    
    
    @IBAction func seeChatLogs(_ sender: Any) {
    }
    
    func showChatControllerForUser(user: UserModel) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ChatLogStoryboard", bundle: nil)
        let chatVC = storyBoard.instantiateViewController(withIdentifier: "ChatLogViewController") as! ChatLogViewController
        chatVC.user = user
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let e {
            print(e)
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "SignInStoryboard", bundle: nil)
        let signInVc = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        signInVc.modalPresentationStyle = .fullScreen
        self.present(signInVc, animated: true, completion: nil)
    }
    
    @objc func handleNewMessage() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "NewMessageStoryboard", bundle: nil)
        let newMessage = storyBoard.instantiateViewController(withIdentifier: "NewMessageVC") as! NewMessageViewController
        newMessage.MessageVC = self
        let naviVC = UINavigationController(rootViewController: newMessage)
        self.present(naviVC, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        let partnerId = message.chatPartnerId()
        let childRef = Database.database().reference().child("users").child(partnerId!)
        childRef.observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let user = UserModel(id: partnerId, email: (dictionary["email"] as! String), name: (dictionary["name"] as! String), profileImageUrl: (dictionary["profileImageUrl"] as! String))
            self.showChatControllerForUser(user: user)
        }) { (err) in
            
        }
        
    }
    
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
