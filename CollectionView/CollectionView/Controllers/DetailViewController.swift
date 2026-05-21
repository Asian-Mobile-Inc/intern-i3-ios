//
//  DetailViewController.swift
//  CollectionView
//
//  Created by Văn Tiến on 18/05/2026.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    let item : Task
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    init(item: Task) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        taskTitle.text = item.title
        taskDescription.text = item.description
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
