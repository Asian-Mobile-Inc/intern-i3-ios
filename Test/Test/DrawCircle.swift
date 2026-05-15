//
//  DrawCircle.swift
//  Test
//
//  Created by Văn Tiến on 24/04/2026.
//

import UIKit

class DrawCircle : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: CGRect(x: rect.width * 0.05,
                                               y: rect.height * 0.3,
                                               width: rect.width * 0.9,
                                               height: rect.width * 0.9))
     
        UIColor.red.setStroke()
        UIColor.blue.setFill()
        path.lineWidth = 3
        path.stroke()
        path.fill()
    }
}
