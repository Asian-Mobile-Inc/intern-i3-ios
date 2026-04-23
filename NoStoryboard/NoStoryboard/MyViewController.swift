//
//  MyViewController.swift
//  NoStoryboard
//
//  Created by Văn Tiến on 22/04/2026.
//

import UIKit

class MyViewController : UIViewController {
    private let label : UILabel = {
        let label = UILabel()
        label.text = "Hello 12345"
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
    }
}
