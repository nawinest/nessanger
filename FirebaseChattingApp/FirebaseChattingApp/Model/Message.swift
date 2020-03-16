//
//  Message.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 28/2/2563 BE.
//  Copyright © 2563 Nawin Phunsawat. All rights reserved.
//

import Foundation
import Firebase

class Message: NSObject {
    var fromId: String?
    var toId: String?
    var timstamp: NSNumber?
    var text: String?
    var imageUrl: String?
    var msgImageWidth: NSNumber?
    var msgImageHeight: NSNumber?
    
    func chatPartnerId() -> String? {
        return (fromId == Auth.auth().currentUser?.uid ? toId : fromId)!
    }
    
    init (dictionary: [String: AnyObject]) {
        super.init()
        self.fromId = dictionary["fromId"] as? String
        self.toId = dictionary["toId"] as? String
        self.timstamp = dictionary["timeStamp"] as? NSNumber
        self.text = dictionary["text"] as? String
        self.imageUrl = dictionary["imageUrl"] as? String
        self.msgImageWidth = dictionary["msgImageWidth"] as? NSNumber
        self.msgImageHeight = dictionary["msgImageHeight"] as? NSNumber
    }
}
