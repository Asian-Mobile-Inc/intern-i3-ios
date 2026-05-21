//
//  CollectionView.swift
//  CollectionView
//
//  Created by Văn Tiến on 13/05/2026.
//

import UIKit

class CollectionView: UIView {
    @IBOutlet var contentView : UIView!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var subtitleLabel : UILabel!
    @IBOutlet weak var addingButton : UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromXib()
    }
    
    func loadFromXib() {
        Bundle.main.loadNibNamed("CollectionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        registerCells()
    }
    
    func registerCells(){
        let nib = UINib(nibName: "CollectionViewCell", bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
