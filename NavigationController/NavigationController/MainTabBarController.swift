//
//  ViewController.swift
//  NavigationController
//
//  Created by Văn Tiến on 07/05/2026.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabs()
    }

    private func setupTabs() {
        let HomeVC = createNav(with: HomeViewController(), title: "Home", image: UIImage(systemName: "house"))
        let tab2 = createNav(with: UIViewController(), title: "Khám phá", image: UIImage(systemName: "magnifyingglass"))
        let tab3 = createNav(with: UIViewController(), title: "Lịch sử", image: UIImage(systemName: "clock"))
        let tab4 = createNav(with: UIViewController(), title: "Cá nhân", image: UIImage(systemName: "person"))
        
        self.setViewControllers([HomeVC, tab2, tab3, tab4], animated: true)
    }
    
    
    private func createNav (with rootVC : UIViewController, title: String, image: UIImage?) -> UIViewController {
        let nav = UINavigationController(rootViewController: rootVC)
        nav.tabBarItem.title = "Hehe"
        nav.tabBarItem.image = image
        rootVC.view.backgroundColor = .systemBackground
        rootVC.navigationController?.title = title
        
        return nav
    }
}

