//
//  ViewController.swift
//  AutoLayout
//
//  Created by Văn Tiến on 21/04/2026.
//

import UIKit

class ViewController: UIViewController {

    private let landscapeImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "cloud.sun.fill")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Ở một nơi nào đó rất rất xaaa"
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    //Ham tao view
    private func createStatView(icon: String, value: String, title: String) -> UIStackView {
        //tao icon tu UIImageView, tint = blue
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .systemBlue
        //value = UIlabel
        let valueLabel = UILabel(); valueLabel.text = value
        valueLabel.font = .boldSystemFont(ofSize: 20)
        //titleLabel
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .gray
        
        //add arangesubview, axis, aligment, spacing
        let stack = UIStackView(arrangedSubviews: [iconView, valueLabel, titleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }
    
    private lazy var infoStackView: UIStackView = {
        let tempStat = createStatView(icon: "thermometer", value: "14°C", title: "Nhiệt độ")
        let humidStat = createStatView(icon: "humidity", value: "85%", title: "Độ ẩm")
        let cloudStat = createStatView(icon: "smoke.fill", value: "90%", title: "Tỷ lệ mây")
        
        let statsRow = UIStackView(arrangedSubviews: [tempStat, humidStat, cloudStat])
        statsRow.axis = .horizontal
        statsRow.distribution = .equalSpacing
        
        let mainInfoStack = UIStackView(arrangedSubviews: [locationLabel, statsRow])
        mainInfoStack.axis = .vertical
        mainInfoStack.spacing = 32
        mainInfoStack.translatesAutoresizingMaskIntoConstraints = false
        return mainInfoStack
    }()
    
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(landscapeImage)
        view.addSubview(infoStackView)
        
        let safeArea = view.safeAreaLayoutGuide
        let margin: CGFloat = 20
        
        portraitConstraints = [
            landscapeImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: margin),
            landscapeImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            landscapeImage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            landscapeImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            infoStackView.topAnchor.constraint(equalTo: landscapeImage.bottomAnchor, constant: 30),
            infoStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            infoStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin)
        ]
        
        landscapeConstraints = [
            landscapeImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: margin),
            landscapeImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            landscapeImage.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -margin),
            landscapeImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            
            infoStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: landscapeImage.trailingAnchor, constant: 40),
            infoStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin)
        ]
        
        updateLayout(for: view.bounds.size)
    }
        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
        
            coordinator.animate(alongsideTransition: { _ in
                self.updateLayout(for: size)
            }, completion: nil)
        }
        
        private func updateLayout(for size: CGSize) {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.deactivate(landscapeConstraints)
            
            if size.width > size.height {
                NSLayoutConstraint.activate(landscapeConstraints)
            } else {
                NSLayoutConstraint.activate(portraitConstraints)
            }
            self.view.layoutIfNeeded()
        }
    
}

