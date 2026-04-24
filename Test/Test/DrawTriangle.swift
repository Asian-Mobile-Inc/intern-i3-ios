//
//  DrawTriangle.swift
//  Test
//
//  Created by Văn Tiến on 24/04/2026.
//

import UIKit

class DrawTriangle : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width / 2, y: rect.height * 1 / 3))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 2 / 3))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 2 / 3))
        path.close()
        
        UIColor.blue.setStroke()
        UIColor.yellow.setFill()
        path.lineWidth = 3
        path.stroke()
        path.fill()
        
    }
}

