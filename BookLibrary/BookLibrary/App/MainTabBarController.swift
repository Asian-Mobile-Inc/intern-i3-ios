//
//  MainTabBarController.swift
//  BookLibrary
//
//  Created by Văn Tiến on 01/06/2026.
//

import UIKit

final class MainTabBarController: UITabBarController {

    private var isPresentSheet = false
    private let container = AppDIContainer()

  private lazy var btnMiddle: UIButton = {
    let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    btn.setTitle("", for: .normal)
    btn.backgroundColor = UIColor.red
    btn.layer.cornerRadius = 30
    btn.layer.shadowColor = UIColor.black.cgColor
    btn.layer.shadowOpacity = 0.25
    btn.layer.shadowOffset = CGSize(width: 0, height: 4)
    btn.layer.shadowRadius = 6
    let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .semibold)
    let icon = UIImage(systemName: "plus", withConfiguration: config)
    btn.setImage(icon, for: .normal)
    btn.tintColor = .white
    btn.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)

    return btn
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
    setValue(CustomTabBar(), forKey: "tabBar")
    setupViewControllers()
    setupUITabBar()
    self.tabBar.addSubview(btnMiddle)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    btnMiddle.frame = CGRect(
      x: (tabBar.bounds.width - 60) / 2,
      y: -25,
      width: 60,
      height: 60
    )
  }

  private func setupViewControllers() {
    let exploreNav = creatNavigationController(
      rootViewController: container.makeExploreViewController(),
      title: "Explore",
      image: "house",
      selectedImage: "house.fill")

    let searchNav = creatNavigationController(
      rootViewController: container.makeSearchViewController(),
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
    let emptyNav = creatNavigationController(
      rootViewController: UIViewController(), title: "", image: "", selectedImage: "")

    viewControllers = [
      exploreNav,
      searchNav,
      emptyNav,
      libraryNav,
      statsNav,
    ]
  }

  private func creatNavigationController(
    rootViewController: UIViewController,
    title: String,
    image: String,
    selectedImage: String
  ) -> UINavigationController {

    let navController = UINavigationController(rootViewController: rootViewController)
    navController.tabBarItem = UITabBarItem(
      title: title,
      image: UIImage(systemName: image),
      selectedImage: UIImage(systemName: selectedImage))
    return navController

  }

  func setupUITabBar() {
    tabBar.tintColor = .red
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

  func presentCenterAction() {
      isPresentSheet = true
    guard presentedViewController == nil else {
      return
    }

    let addVC = AddManualBookViewController()
    let nav = UINavigationController(rootViewController: addVC)

    nav.modalPresentationStyle = .pageSheet

      present(nav, animated: true) { [weak self]  in
          self?.isPresentSheet = false
      }
  }

  @objc func centerButtonTapped() {
      print("Center button tapped")
    presentCenterAction()
  }
}

extension MainTabBarController: UITabBarControllerDelegate {

  func tabBarController(
    _ tabBarController: UITabBarController,
    shouldSelect viewController: UIViewController
  ) -> Bool {
    guard let index = viewControllers?.firstIndex(of: viewController) else {
      return true
    }

    if index == 2 {
      presentCenterAction()
      return false
    }

    return true
  }
}
