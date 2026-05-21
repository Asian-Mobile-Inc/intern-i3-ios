//
//  GoalListViewController.swift
//  VCLifecycle
//
//  Created by Văn Tiến on 05/05/2026.
//

import UIKit

class GoalListViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    
    var goals = Goal.sampleData
    var pendingUpdateIndex : Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    //khi view cbi xuat hien, kiem tra su thay doi , lay indexpath, reload row tai index do, sep pending = nill
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = pendingUpdateIndex {
            let ip = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [ip], with: .automatic)
            pendingUpdateIndex = nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animateCells()
    }
    
    func setupTableView() {
        let nib = UINib(nibName: "GoalCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "GoalCell")
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.rowHeight  = 88
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle  = .none
        tableView.contentInset    = UIEdgeInsets(top: 8, left: 0, bottom: 80, right: 0)
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}

extension GoalListViewController {
    func animateCells() {
        let cells = tableView.visibleCells
        cells.forEach {
            $0.alpha = 0
            $0.transform = CGAffineTransform(translationX: 0, y: 40)
        }
       
        for (index, cell) in cells.enumerated() {
            UIView.animate(
                withDuration: 0.45,
                delay: Double(index) * 0.07,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.5,
                options: .curveEaseOut
            ) {
                cell.alpha = 1
                cell.transform = .identity
            }
        }
    }
}

extension GoalListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as! GoalCell
        let goal = goals[indexPath.row]
        cell.configure(with: goal)
        return cell
    }
}

extension GoalListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        pushDetail(goal: goals[indexPath.row], index: indexPath.row)
        pushDetail(at: indexPath.row, goal: goals[indexPath.row])
    }
}

extension GoalListViewController: GoalCellDelegate {
    func goalCell(_ cell: GoalCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension GoalListViewController {
    // ham push -> detail, nhan index, goal, tao detailVC, gan thuoc tinh, delegate, push
    func pushDetail (at index: Int?, goal : Goal, ) {
        let detailVC = GoalDetailViewController(nibName: "GoalDetailViewController", bundle: nil)
        detailVC.goal = goal
        detailVC.goalIndex = index
        detailVC.delegate = self
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension GoalListViewController: GoalDetailDelegate {
    
    // ham update goal, nhan goal moi, index, kiem tra index, gan goal moi, pending = index
    func goalDetail(_ goal: Goal, at index: Int?) {
        if let index = index {
            goals[index] = goal
            pendingUpdateIndex = index
        }
    }
}

