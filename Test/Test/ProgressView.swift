//
//  ProgressView.swift
//  Test
//
//  Created by Văn Tiến on 24/04/2026.
//

import UIKit

class ProgressBar: UIView {

    var progress: CGFloat = 0 {
        didSet {
            progress = max(0, min(1, progress))  // clamp 0...1
            setNeedsDisplay()
        }
    }

    var trackColor: UIColor = UIColor.systemGray5
    var progressColor: UIColor = UIColor.systemBlue
    var cornerRadius: CGFloat = 6

    override func draw(_ rect: CGRect) {
        let inset: CGFloat = 2
        let trackRect = bounds.insetBy(dx: inset, dy: inset)

        let track = UIBezierPath(roundedRect: trackRect, cornerRadius: cornerRadius)
        trackColor.setFill()
        track.fill()

        guard progress > 0 else { return }

        let progressWidth = (trackRect.width - inset * 2) * progress + cornerRadius * 2
        let progressRect = CGRect(x: trackRect.minX + inset,
                                  y: trackRect.minY + inset,
                                  width: min(progressWidth, trackRect.width - inset * 2),
                                  height: trackRect.height - inset * 2)

   
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.saveGState()
        track.addClip()

        let fill = UIBezierPath(roundedRect: progressRect, cornerRadius: cornerRadius - inset)
        progressColor.setFill()
        fill.fill()

        ctx.restoreGState()
    }
}

