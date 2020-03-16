//
//  PreScenceViewController.swift
//  FirebaseChattingApp
//
//  Created by Nawin Phunsawat on 16/3/2563 BE.
//  Copyright (c) 2563 Nawin Phunsawat. All rights reserved.
//

import UIKit

class PreScenceViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buttonNext: UIButton!
    
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonNext()
        mainView.backgroundColor = UIColor.init(r: 23, g: 44, b: 87)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }
    
    func setupButtonNext() {
        self.buttonNext.backgroundColor = .white
        self.buttonNext.setTitleColor(UIColor.init(r: 23, g: 44, b: 87), for: .normal)
        self.buttonNext.layer.cornerRadius = 8
        self.buttonNext.clipsToBounds = true
        self.buttonNext.setTitle("Get started", for: .normal)
        buttonNext.addTarget(self, action: #selector(gotoNextPage), for: .touchUpInside)
    }
    
    @objc func gotoNextPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated:true, completion: nil)
        
    }
    
    
}
