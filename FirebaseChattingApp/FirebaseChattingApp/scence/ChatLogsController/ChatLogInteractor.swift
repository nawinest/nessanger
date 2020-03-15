//
//  ChatLogInteractor.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 27/2/2563 BE.
//  Copyright (c) 2563 Nawin Phunsawat. All rights reserved.
//

import UIKit

protocol ChatLogInteractorInterface {
    func startDoingSomething(aRequest: ChatLogModels.Request)
    var model: Any? { get }
}

final class ChatLogInteractor: ChatLogInteractorInterface {
    var presenter: ChatLogPresenterInterface!
    var model: Any?
    
    var worker: ChatLogWorker = ChatLogWorker(with: ChatLogService())
    
    // MARK: - Business logic
    
    func startDoingSomething(aRequest: ChatLogModels.Request) {
        worker.getSomething(aQueryString: "") { (aAny) in
            self.model = aAny
            
            //Convert Any object to Response Model
            self.presenter.presentSomething(aResponse: ChatLogModels.Respoonse())
        }
    }
}

