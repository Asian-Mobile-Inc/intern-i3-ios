//
//  GoalDetailViewController.swift
//  VCLifecycle
//
//  Created by Văn Tiến on 05/05/2026.
//

import UIKit

//delegate goal detail
protocol GoalDetailDelegate: AnyObject {
    func goalDetail(_ goal : Goal,at index : Int?)
}
class GoalDetailViewController: UIViewController {

    var goal: Goal!
    var goalIndex: Int?
    
    // khai bao delegate
    weak var delegate : GoalDetailDelegate?
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    @IBOutlet weak var doneSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateUI()
        setupStyle()
        
        // Do any additional setup after loading the view.
    }
    
    // thoat view, lay goal va update
     //goi ham cua view cha delegate voi doi so o subview nay
    override func viewWillDisappear(_ animated: Bool) {
        let updateGoal = collectGoalFromUI()
        delegate?.goalDetail(updateGoal, at: goalIndex)
    }
    private func populateUI() {
       titleField.text = goal.title
       detailTextView.text = goal.detail
       deadlinePicker.date = goal.deadline
       doneSwitch.isOn = goal.isDone

       let priorities = Priority.allCases
       prioritySegment.removeAllSegments()
       priorities.enumerated().forEach {
           prioritySegment.insertSegment(withTitle: $1.rawValue, at: $0, animated: false)
       }
       prioritySegment.selectedSegmentIndex = priorities.firstIndex(of: goal.priority) ?? 1
   }

   private func collectGoalFromUI() -> Goal {
       var updated = goal!
       updated.title    = titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? goal.title
       updated.detail   = detailTextView.text ?? ""
       updated.deadline = deadlinePicker.date
       updated.isDone   = doneSwitch.isOn
       updated.priority = Priority.allCases[prioritySegment.selectedSegmentIndex]
       return updated
   }

   private func setupStyle() {
       view.backgroundColor = .systemGroupedBackground
       detailTextView.layer.cornerRadius = 10
       detailTextView.layer.borderWidth  = 1
       detailTextView.layer.borderColor  = UIColor.separator.cgColor
   }
}
