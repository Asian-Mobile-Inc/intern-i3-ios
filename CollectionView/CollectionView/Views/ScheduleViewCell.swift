//
//  ScheduleViewCell.swift
//  CollectionView
//
//  Created by Văn Tiến on 15/05/2026.
//

import UIKit

class ScheduleViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
