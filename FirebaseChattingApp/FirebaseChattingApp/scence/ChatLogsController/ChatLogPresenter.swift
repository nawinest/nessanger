//
//  ChatLogPresenter.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 27/2/2563 BE.
//  Copyright (c) 2563 Nawin Phunsawat. All rights reserved.
//

import UIKit

protocol ChatLogPresenterInterface {
    func presentSomething(aResponse: ChatLogModels.Respoonse)
}

class ChatLogPresenter: ChatLogPresenterInterface {
    weak var viewController: ChatLogView!
    
    func presentSomething(aResponse: ChatLogModels.Respoonse) {
        //Transform Response Model to Displayed Model
        viewController.displaySomething(aDisplay: ChatLogModels.ViewModel.Displayed())
    }
}

