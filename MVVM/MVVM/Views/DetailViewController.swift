//
//  DetailViewController.swift
//  MVVM
//
//  Created by Văn Tiến on 22/05/2026.
//

import UIKit


class DetailViewController: UIViewController {

    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskTitle: UITextField!
    
    enum UpdateTask {
        case updatedTask(Todo)
        case deletedTask(Todo)
    }
    
    private let viewModel : DetailViewModel
    var onUpdatedTask : ((UpdateTask) -> Void)?
    
    init(viewModel : DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "DetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.viewDidLoad()
    }

    func bindViewModel() {
        viewModel.onOutput = { [weak self] state in
            switch state {
                
            case .didUpdatedTask(let updatedTask):
                self?.onUpdatedTask?(.updatedTask(updatedTask))
                self?.navigationController?.popViewController(animated: true)
                
            case .didDeleteTask(let deletedTask):
                self?.onUpdatedTask?(.deletedTask(deletedTask))
                self?.navigationController?.popViewController(animated: true)
                
            case .showTask(let title, let isDone):
                self?.taskTitle.text = title
                self?.taskDescription.text = isDone ? "Completed" : "Not completed"
                
            case .showError(let message) :
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
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
    @IBAction func didTapDeleteTask(_ sender: Any) {
        viewModel.deleteTask()
    }
    
    @IBAction func didTapUpdateTask(_ sender: Any) {
        viewModel.updateTask(title: taskTitle.text, description: taskDescription.text)
    }
}
