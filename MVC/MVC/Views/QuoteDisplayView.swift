//
//  QuoteDisplayView.swift
//  MVC
//
//  Created by Văn Tiến on 12/05/2026.
//

import UIKit

class QuoteDisplayView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromXib()
    }
    
    private func loadFromXib() {
        Bundle.main.loadNibNamed("QuoteDisplayView", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        registerCells()
    }
    
    private func registerCells() {
        let nib = UINib(nibName: "QuoteCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "QuoteCell")
    }
}
