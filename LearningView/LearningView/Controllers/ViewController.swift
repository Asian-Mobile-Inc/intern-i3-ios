//
//  TableViewController.swift
//  LearningView
//
//  Created by Văn Tiến on 20/04/2026.
//

import UIKit

class ViewController: UIViewController{
    // them Ui bang IBOutlet va keo tha file .xib
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var tasks: [TaskModel] = [
            TaskModel(title: "Learning UIkit", description: "Practice in frame, bounds and life cycle", isCompleted: true),
            TaskModel(title: "Doing Exercise", description: "Complete a 5km run within 30 minutes", isCompleted: false)
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        addButton.layer.cornerRadius = 20
        addButton.clipsToBounds = true
    }
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
    }
    @IBAction func addButtonTapped(_ sender: UIButton) {
        showAddTaskPopup()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.configure(with: tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tasks[indexPath.row].isExpanded ? 120 : 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        tasks[indexPath.row].isExpanded.toggle()

        tableView.beginUpdates()

        if let cell = tableView.cellForRow(at: indexPath) as? TaskCell {
            cell.configure(with: tasks[indexPath.row])
        }
        
        tableView.endUpdates()
    }
}

extension ViewController {
    
    func showAddTaskPopup() {
        
    }
}
