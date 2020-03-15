//
//  ChatLogService.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 27/2/2563 BE.
//  Copyright (c) 2563 Nawin Phunsawat. All rights reserved.
//

import UIKit
import TakoBase

class ChatLogService {

    /*
    *if fail, return error code
    *if success, transform to models (raw)
    */
 
    // MARK: - Calling API Manager
    func requestSomething(aSuccess: @escaping (Any) -> (), aFailure: @escaping (_ error: String?) -> ()) {

        // TODO: Do the work
        let api = APIManager.init(endpoint: "",
                                  method: .get)
        api.call(parameters: [:],
                 headersAdditional: [:],
                 encoding: nil,
                 fail: { (aStatusCode, aJSON) in
                    //TODO : implement fail cases
                    aFailure("error")
        }) { (aJSON) in
            if (aJSON["code"].string == "success") {
                // TODO: Format the response from the Api and pass the result back to the Presenter
                aSuccess("")
            }
        }
    }
}
