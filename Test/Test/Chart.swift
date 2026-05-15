//
//  Chart.swift
//  Test
//
//  Created by Văn Tiến on 24/04/2026.
//

import UIKit

class PieChartView: UIView {

    struct Slice {
        let value: CGFloat
        let color: UIColor
    }

    var slices: [Slice] = [] { didSet { setNeedsDisplay() } }

    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 10
        let total = slices.reduce(0) { $0 + $1.value }

        var startAngle: CGFloat = -.pi / 2

        for slice in slices {
            let endAngle = startAngle + (slice.value / total) * .pi * 2

            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center,
                        radius: radius,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: true)
            path.close()

            slice.color.setFill()
            path.fill()

            UIColor.white.setStroke()
            path.lineWidth = 2
            path.stroke()

            startAngle = endAngle
        }
    }
}
