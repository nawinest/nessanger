//
//  MessageCell.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 26/2/2563 BE.
//  Copyright © 2563 Nawin Phunsawat. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: UITableViewCell {
    @IBOutlet weak var detailText: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var message: Message? {
        didSet {
            setNameAndAvatar()
        }
    }
    
    private func setNameAndAvatar() {
        if let id = message?.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observe(.value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.name.text = dictionary["name"] as? String
                    self.detailText.text = self.message?.text
                    if let second = self.message?.timstamp?.doubleValue {
                        let timeStamp = Date(timeIntervalSince1970: second)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "hh:mm a"
                        self.timeLabel.text = dateFormatter.string(from: timeStamp)
                    }
                    self.imageCell.loadImageFromCache(urlImageString: dictionary["profileImageUrl"] as! String)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageCell.clipsToBounds = true
        self.imageCell.layer.cornerRadius = imageCell.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
