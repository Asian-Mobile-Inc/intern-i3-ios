//
//  ReviewViewController.swift
//  CollectionView
//
//  Created by Văn Tiến on 15/05/2026.
//

import UIKit

class ReviewViewController: UIViewController {
    var todoList : TodoList = TodoList.getSampleData()
    @IBOutlet weak var mainCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCollection.delegate = self
        mainCollection.dataSource = self
        
       setupUI()
        
    }

    func setupUI() {
        
        mainCollection.register(UINib(nibName: "HorizontalWrapperCell", bundle: nil), forCellWithReuseIdentifier: "HorizontialWrapperCell")
        mainCollection.register(UINib(nibName: "ScheduleViewCell", bundle: nil), forCellWithReuseIdentifier: "ScheduleViewCell")
        mainCollection.register(UINib(nibName: "OngoingViewCell", bundle: nil), forCellWithReuseIdentifier: "OngoingViewCell")
        mainCollection.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        
    }

}

extension ReviewViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return todoList.taskTypes.count
        }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numSection = 0
        if section == 0 {
            numSection = 1
        } else  {
            let totalItems = todoList.taskTypes[section].Tasks.count
            numSection = min(2, totalItems)
        }
        
       return numSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontialWrapperCell", for: indexPath) as! HorizontalWrapperCell
            categoryCell.configure(with: todoList.taskTypes[indexPath.section])
            
            categoryCell.didSelectItem = { [weak self] selectedData in
                guard let self = self else { return }
                
                let detailVC = DetailViewController(item: selectedData)
                
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            return categoryCell
        }
        else if indexPath.section == 1 {
            let scheduleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleViewCell", for: indexPath) as! ScheduleViewCell
            scheduleCell.title.text = todoList.taskTypes[1].Tasks[indexPath.row].title
            scheduleCell.taskDescription.text = todoList.taskTypes[1].Tasks[indexPath.row].description
            scheduleCell.image.image = UIImage(named: String(indexPath.row))
            return scheduleCell
        }
        else {
            let ongoingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OngoingViewCell", for: indexPath) as! OngoingViewCell
            ongoingCell.title.text = todoList.taskTypes[indexPath.section].Tasks[indexPath.row].title
            ongoingCell.progess.text = todoList.taskTypes[indexPath.section].Tasks[indexPath.row].description
            ongoingCell.image.image = UIImage(named: String(9 - indexPath.row))
            return ongoingCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as! SectionHeaderView
        header.titleLabel.text = todoList.taskTypes[indexPath.section].type
        return header
    }
}

extension ReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width * 2 / 5 + 10)
        } else {
            return CGSize(width: collectionView.frame.width - 32, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        }
        return UIEdgeInsets(top: 10, left: 16, bottom: 20, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let selectedItem = todoList.taskTypes[indexPath.section].Tasks[indexPath.row]
            let detailVC = DetailViewController(item: selectedItem)
            
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}


