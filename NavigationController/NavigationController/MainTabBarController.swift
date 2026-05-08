//
//  ViewController.swift
//  NavigationController
//
//  Created by Văn Tiến on 07/05/2026.
//

import UIKit

class MainTabBarController: UITabBarController {

    let btnMiddle : UIButton = {
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
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        btnMiddle.frame = CGRect(x: Int(self.tabBar.bounds.width)/2 - 30, y: -25, width: 60, height: 60)
    }
    override func loadView() {
        super.loadView()
        self.tabBar.addSubview(btnMiddle)
        setupCustomTabBar()
    }
    
    func setupCustomTabBar() {
        let path : UIBezierPath = getPathForTabBar()
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 3
        shape.strokeColor = UIColor.yellow.cgColor
        shape.fillColor = UIColor.yellow.cgColor
        self.tabBar.layer.insertSublayer(shape, at: 0)
        self.tabBar.itemWidth = 40
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = 180
        self.tabBar.tintColor = UIColor.red
    }
    
    private func setupTabs() {
        let HomeVC = createNav(with: HomeViewController(), title: "Home", image: UIImage(systemName: "house"))
        let tab2 = createNav(with: UIViewController(), title: "Khám phá", image: UIImage(systemName: "magnifyingglass"))
        let tab3 = createNav(with: UIViewController(), title: "Lịch sử", image: UIImage(systemName: "clock"))
        let tab4 = createNav(with: UIViewController(), title: "Cá nhân", image: UIImage(systemName: "person"))
        let tab5 = createNav(with: UIViewController(), title: "", image: nil)
        
        self.setViewControllers([HomeVC, tab2, tab5, tab3, tab4], animated: true)
    }
    
    func getPathForTabBar() -> UIBezierPath {
        let frameWidth = self.tabBar.bounds.width
        let frameHeight = self.tabBar.bounds.height + 20
        let holeWidth = 150
        let holeHeight = 50
        let leftXUntilHole = Int(frameWidth/2) - Int(holeWidth/2)
        
        let path : UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: leftXUntilHole , y: 0)) // 1.Line
        path.addCurve(to: CGPoint(x: leftXUntilHole + (holeWidth/3), y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*6,y: 0), controlPoint2: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*8, y: holeHeight/2)) // part I
        
        path.addCurve(to: CGPoint(x: leftXUntilHole + (2*holeWidth)/3, y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2/5, y: (holeHeight/2)*6/4), controlPoint2: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2 + (holeWidth/3)/3*3/5, y: (holeHeight/2)*6/4)) // part II
        
        path.addCurve(to: CGPoint(x: leftXUntilHole + holeWidth, y: 0), controlPoint1: CGPoint(x: leftXUntilHole + (2*holeWidth)/3,y: holeHeight/2), controlPoint2: CGPoint(x: leftXUntilHole + (2*holeWidth)/3 + (holeWidth/3)*2/8, y: 0)) // part III
        path.addLine(to: CGPoint(x: frameWidth, y: 0)) // 2. Line
        path.addLine(to: CGPoint(x: frameWidth, y: frameHeight)) // 3. Line
        path.addLine(to: CGPoint(x: 0, y: frameHeight)) // 4. Line
        path.addLine(to: CGPoint(x: 0, y: 0)) // 5. Line
        path.close()
        return path
    }

    
    private func createNav (with rootVC : UIViewController, title: String, image: UIImage?) -> UIViewController {
        let nav = UINavigationController(rootViewController: rootVC)
        nav.tabBarItem.title = "Hehe"
        nav.tabBarItem.image = image
        nav.tabBarItem.image?.withTintColor(UIColor.red)
        rootVC.view.backgroundColor = .systemBackground
        rootVC.navigationController?.title = title
        
        return nav
    }
}

