//
//  ChatLogRouter.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 27/2/2563 BE.
//  Copyright (c) 2563 Nawin Phunsawat. All rights reserved.
//

import UIKit

protocol ChatLogRouterInterface {
  func navigateToViewController()
}

final class ChatLogRouter: ChatLogRouterInterface {
  weak var viewController: ChatLogViewController!

  // MARK: - Navigation

    func navigateToViewController() {
        // TODO: Navigate to viewController
    }
}
