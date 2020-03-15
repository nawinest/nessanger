//
//  ChatLogWorker.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 27/2/2563 BE.
//  Copyright (c) 2563 Nawin Phunsawat. All rights reserved.
//

import UIKit

protocol ChatLogWorkerInterface {
  func getSomething(aQueryString: String, aCompletion: @escaping (Any) -> Void)
}

final class ChatLogWorker {

    var service: ChatLogService!
    
    init(with aService: ChatLogService) {
        service = aService
    }

  // MARK: - Business Logic

    func getSomething(aQueryString: String, aCompletion: @escaping (Any) -> Void) {
        service.requestSomething(aSuccess: { (aAny) in
            aCompletion(aAny)
        }) { (aErrorCode) in
            if let code = aErrorCode {
                print(code)
            }
        }
    }
}
