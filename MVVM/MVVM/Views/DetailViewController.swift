//
//  DetailViewController.swift
//  MVVM
//
//  Created by Văn Tiến on 22/05/2026.
//

import UIKit
import Combine


class DetailViewController: UIViewController {

    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskTitle: UITextField!
    
    enum UpdateTask {
        case updatedTask(Todo)
        case deletedTask(Todo)
    }
    private var cancellables = Set<AnyCancellable>()
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
        setupUI()
    }
    func setupUI() {
        taskTitle.text = viewModel.task.name
        taskDescription.text = viewModel.task.isDone ? "Completed" : "Uncomplete"
    }
    func bindViewModel() {
        viewModel.$task
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedTask in
                self?.onUpdatedTask?(.updatedTask(updatedTask))
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.didDeleteTask
            .receive(on: DispatchQueue.main)
            .sink { [weak self] deletedTask in
                self?.onUpdatedTask?(.deletedTask(deletedTask))
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        viewModel.showError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
                self?.setupUI()
            }
            .store(in: &cancellables)
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
