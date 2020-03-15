//
//  Message.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 28/2/2563 BE.
//  Copyright © 2563 Nawin Phunsawat. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    var fromId: String?
    var toId: String?
    var timstamp: NSNumber?
    var text: String?
    var imageUrl: String?
    
    func chatPartnerId() -> String? {
        return (fromId == Auth.auth().currentUser?.uid ? toId : fromId)!
    }
}
