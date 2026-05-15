//
//  DrawLine.swift
//  Test
//
//  Created by Văn Tiến on 24/04/2026.
//

import UIKit

class DrawLine : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width / 2, y: rect.height / 2))
        path.close()
        
        UIColor.red.setStroke()
        path.lineWidth = 3
        path.stroke()
    }
}
