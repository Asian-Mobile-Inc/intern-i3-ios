//
//  CustomTabBar.swift
//  BookLibrary
//
//  Created by Văn Tiến on 01/06/2026.
//

import UIKit

class CustomTabBar: UITabBar {
    private let shapeLayer = CAShapeLayer()
    private let notchWidth: CGFloat = 150
    private let notchDepth: CGFloat = 42

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureShapeLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureShapeLayer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.path = makePath().cgPath
    }

    private func configureShapeLayer() {
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.fillColor = UIColor.yellow.cgColor
        layer.insertSublayer(shapeLayer, at: 0)
    }

    private func makePath() -> UIBezierPath {
        let frameWidth = bounds.width
        let frameHeight = bounds.height + 20
        let centerX = frameWidth / 2
        let halfNotch = notchWidth / 2
        let leftX = centerX - halfNotch
        let rightX = centerX + halfNotch

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: leftX, y: 0))

        path.addCurve(
            to: CGPoint(x: centerX, y: notchDepth),
            controlPoint1: CGPoint(x: leftX + notchWidth * 0.20, y: 0),
            controlPoint2: CGPoint(x: centerX - notchWidth * 0.20, y: notchDepth)
        )
        path.addCurve(
            to: CGPoint(x: rightX, y: 0),
            controlPoint1: CGPoint(x: centerX + notchWidth * 0.20, y: notchDepth),
            controlPoint2: CGPoint(x: rightX - notchWidth * 0.20, y: 0)
        )

        path.addLine(to: CGPoint(x: frameWidth, y: 0))
        path.addLine(to: CGPoint(x: frameWidth, y: frameHeight))
        path.addLine(to: CGPoint(x: 0, y: frameHeight))
        path.close()
        return path
    }

}
