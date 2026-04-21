//
//  UserProfileView.swift
//  CustomView
//
//  Created by Văn Tiến on 21/04/2026.
//

import UIKit

class UserProfileView: UIView{
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    private var initialCenter : CGPoint = .zero
    private var startLocation : CGPoint = .zero
    private var isToggle : Bool = false
    
    private var initialDistance: CGFloat = 0
    private var initialBounds: CGRect = .zero
    
    
    @IBInspectable var profileName: String = "Name" {
        didSet { nameLabel.text = profileName }
    }
    
    @IBInspectable var bgColor: UIColor = .systemBlue {
        didSet { contentView.backgroundColor = bgColor }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle(for: type(of: self)).loadNibNamed("UserProfileView", owner: self, options: nil)
        
        addSubview(contentView)
        self.isMultipleTouchEnabled = true
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Setup UI mặc định
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        
        avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
        avatarImageView.tintColor = .systemGray
        avatarImageView.backgroundColor = .white
        avatarImageView.layer.cornerRadius = 15
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = self.bounds
        
        let currentWidth = self.bounds.width
        let currentHeight = self.bounds.height
        
        avatarImageView.frame = CGRect(x: 0, y: 0, width: currentWidth, height: currentHeight * 0.8)
        nameLabel.frame = CGRect(x: 0, y: currentHeight * 0.8, width: currentWidth, height: currentHeight * 0.2)
        
        nameLabel.font = .boldSystemFont(ofSize: currentHeight * 0.5)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        nameLabel.text = "Preview Name"
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let superview = self.superview else { return }
        
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
        
//        let endLocation = touch.location(in: superview)
//        let distance = hypot(endLocation.x - startLocation.x, endLocation.y - startLocation.y)
//        
//        if distance < 5.0 {
//            isToggle.toggle()
//            UIView.animate(withDuration: 0.3) {
//                self.contentView.backgroundColor = self.isToggle ? .blue : .orange
//            }
//        }
    }
    override func touchesMoved (_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let allTounches = event?.allTouches else {return}
        
        if allTounches.count == 1 {
            guard let touch = allTounches.first, let superview = self.superview else {return}
            let currentPos = touch.location(in: superview)
            let deltaX = currentPos.x - startLocation.x
            let deltaY = currentPos.y - startLocation.y
            
            self.center = CGPoint(x: initialCenter.x + deltaX, y: initialCenter.y + deltaY)
        }
        else if allTounches.count == 2 {
            let touchesArray = Array(allTounches)
            let loc1 = touchesArray[0].location(in: self.superview)
            let loc2 = touchesArray[1].location(in: self.superview)
            
            let currentDis = hypot(loc1.x - loc2.x, loc1.y - loc2.y)
            if initialDistance == 0 {return}
            
            let scale = currentDis/initialDistance
            
            let newWidth = initialBounds.width * scale
            let newHeight = initialBounds.height * scale
            
            if newWidth > 80 && newWidth < 300 {
                self.bounds.size = CGSize(width: newWidth, height: newHeight)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let allTounches = event?.allTouches else {return}
        
        if allTounches.count == 1 {
            guard let touch = allTounches.first else {return}
            
            initialCenter = self.center
            startLocation = touch.location(in: self.superview)
        }
        if allTounches.count == 2 {
            let touchesArray = Array(allTounches)
            let loc1 = touchesArray[0].location(in: self.superview)
            let loc2 = touchesArray[1].location(in: self.superview)
            
            initialDistance = hypot(loc1.x - loc2.x, loc1.y - loc2.y)
            
            initialBounds = self.bounds
        }
    }
    
}
