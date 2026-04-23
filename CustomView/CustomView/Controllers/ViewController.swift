//
//  ViewController.swift
//  CustomView
//
//  Created by Văn Tiến on 21/04/2026.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupProfile()
        
    }
    
    private func setupProfile() {
        let profile3 = UserProfileView(frame: CGRect(x: 200, y: 125, width: 150, height: 150))
        profile3.profileName = "Custom Prof 3"
        profile3.bgColor = .systemPurple
        view.addSubview(profile3)
        
        let profile2 = UserProfileView(frame: CGRect(x: 20, y: 280, width: 150, height: 150))
        profile2.profileName = "Custom Prof 2"
        profile2.bgColor = .systemPurple
        view.addSubview(profile2)
    }


}

