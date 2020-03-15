//
//  ChatLogConfigurator.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 27/2/2563 BE.
//  Copyright (c) 2563 Nawin Phunsawat. All rights reserved.
//

import UIKit

final class ChatLogConfigurator {

  // MARK: - Object lifecycle

  static let sharedInstance = ChatLogConfigurator()

  // MARK: - Configuration

  func configure(viewController: ChatLogViewController) {
    let router = ChatLogRouter()
    router.viewController = viewController

    let presenter = ChatLogPresenter()
    presenter.viewController = viewController

    let interactor = ChatLogInteractor()
    interactor.presenter = presenter

    viewController.interactor = interactor
    viewController.router = router
  }
}
