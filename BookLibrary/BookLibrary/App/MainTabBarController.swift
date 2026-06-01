//
//  MainTabBarController.swift
//  BookLibrary
//
//  Created by Văn Tiến on 01/06/2026.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
        setupUITabBar()
    }
    
    private func setupViewControllers() {
        let exploreNav = creatNavigationController(
            rootViewController: ExploreViewController(),
            title: "Explore",
            image: "house",
            selectedImage: "house.fill")
        
        let searchNav = creatNavigationController(
            rootViewController: SearchViewController(),
            title: "Search",
            image: "magnifyingglass",
            selectedImage: "magnifyingglass.fill")
        
        let libraryNav = creatNavigationController(
            rootViewController: LibraryViewController(),
            title: "Library",
            image: "books.vertical",
            selectedImage: "books.vertical.fill")
        
        let statsNav = creatNavigationController(
            rootViewController: StatsViewController(),
            title: "Stats",
            image: "chart.bar",
            selectedImage: "chart.bar.fill")
        
        viewControllers = [
            exploreNav,
            searchNav,
            libraryNav,
            statsNav
        ]
    }
    
    private func creatNavigationController(
        rootViewController : UIViewController,
        title: String,
        image: String,
        selectedImage: String
    ) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem = UITabBarItem(title: title,
                                                image: UIImage(systemName: image),
                                                selectedImage: UIImage(systemName: selectedImage))
        return navController
        
    }
    
    func setupUITabBar() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.backgroundColor = .systemBackground
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
