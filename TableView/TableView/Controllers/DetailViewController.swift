//
//  DetailViewController.swift
//  TableView
//
//  Created by Văn Tiến on 11/05/2026.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailLabel : UILabel!
    @IBOutlet weak var tableview : UITableView!
    @IBOutlet weak var addButton : UIButton!
    
    let index : Int
    var item : Menu
    
    init(index: Int, item: Menu) {
        self.index = index
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    func setupUI() {
        addButton.tintColor = UIColor.yellow
        addButton.backgroundColor = UIColor.green
        detailLabel.text = item.title
    }
    
    func setupTableView() {
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.delegate = self
        tableview.dataSource = self
    }
}

// MARK: - TableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = item.items[indexPath.row].isSelected ? .checkmark : .none
        cell.textLabel?.text = item.items[indexPath.row].name
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - TableViewDelegate
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        item.items[indexPath.row].isSelected.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

