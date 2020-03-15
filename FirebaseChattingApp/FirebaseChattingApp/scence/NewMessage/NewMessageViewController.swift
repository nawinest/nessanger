//
//  NewMessageViewController.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 26/2/2563 BE.
//  Copyright (c) 2563 Nawin Phunsawat. All rights reserved.
//

import UIKit
import Firebase

class NewMessageViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    let cellID = "message"
    var users: [UserModel] = []
    var MessageVC: ViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchUser()
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (dataSnapShot) in
            if let dictionary = dataSnapShot.value as? [String: AnyObject] {
                let user = UserModel(id: dataSnapShot.key ,email: (dictionary["email"] as! String), name: (dictionary["name"] as! String), profileImageUrl: (dictionary["profileImageUrl"] as! String))
                self.users.append(user)
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
            }
        }) { (error) in
            print(error)
        }
    }
}

extension NewMessageViewController: UITableViewDelegate, UITableViewDataSource  {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = self.mainTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MessageCell
        cell.name.text = user.name ?? ""
        cell.detailText.text = user.email ?? ""
        if let image = user.profileImageUrl {
            cell.imageCell.loadImageFromCache(urlImageString: image)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.MessageVC?.showChatControllerForUser(user: user)
        }
    }
    
    func showChatController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "ChatLogStoryboard", bundle: nil)
        let chatVC = storyBoard.instantiateViewController(withIdentifier: "ChatLogViewController") as! ChatLogViewController
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}

