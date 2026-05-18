//
//  HorizontalWrapperCell.swift
//  CollectionView
//
//  Created by Văn Tiến on 18/05/2026.
//

import UIKit

class HorizontalWrapperCell: UICollectionViewCell {
    @IBOutlet weak var childCollectionView: UICollectionView!
    var datas = TodoList.getSampleData().taskTypes[0].Tasks
    var didSelectItem: ((Task) -> (Void))?
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        childCollectionView.frame = contentView.bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        datas  = []
        childCollectionView.reloadData()
    }
    
    func setup() {
        childCollectionView.delegate = self
        childCollectionView.dataSource = self
        childCollectionView.register(UINib(nibName: "CategoryViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryViewCell")
    }
    
    func configure(with data: TaskTypes) {
        self.datas = data.Tasks
        self.childCollectionView.reloadData()
        self.childCollectionView.layoutIfNeeded()
    }
}

extension HorizontalWrapperCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryViewCell", for: indexPath) as! CategoryViewCell
        categoryCell.imageView.image = UIImage(named: String(indexPath.row))
        categoryCell.numberTasks.text = "\(datas[indexPath.row].description)"
        categoryCell.titleLabel.text = datas[indexPath.row].title
        return categoryCell
    }
    
    
}

extension HorizontalWrapperCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 2 / 5
        return CGSize(width: width, height: width + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = datas[indexPath.row]
        didSelectItem?(selectedItem)
    }
}

