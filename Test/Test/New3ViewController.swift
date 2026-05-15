//
//  NewViewController.swift
//  Test
//
//  Created by Văn Tiến on 24/04/2026.
//

import UIKit

class New3ViewController: UIViewController {

    let progress = ProgressBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        let chart = PieChartView(frame: CGRect(x: (view.bounds.width - 300) / 2, y: 50, width: 300, height: 300))
        chart.slices = [
            .init(value: 40, color: .systemBlue),
            .init(value: 30, color: .systemGreen),
            .init(value: 20, color: .systemOrange),
            .init(value: 10, color: .systemRed),
        ]
        chart.backgroundColor = .clear
        view.addSubview(chart)
        
//        let circle = DrawCircle(frame: view.bounds)
//        view.addSubview(circle)
//        
//        let triangle = DrawTriangle(frame: view.bounds)
//        view.addSubview(triangle)
//        let line = DrawLine(frame: view.bounds)
//        view.addSubview(line)
        
        view.addSubview(progress)
        progress.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progress.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progress.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            progress.widthAnchor.constraint(equalToConstant: 300),
            progress.heightAnchor.constraint(equalToConstant: 40)
        ])
        progress.progress = 0.7
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
