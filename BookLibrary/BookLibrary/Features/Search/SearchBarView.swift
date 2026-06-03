//
//  SearchBarView.swift
//  BookLibrary
//
//  Created by Văn Tiến on 02/06/2026.
//

import UIKit
import Combine

class SearchBarView: UIView {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var stackView: UIImageView!
    
    public let textPublisher = PassthroughSubject<String, Never>()
       
   override init(frame: CGRect) {
       super.init(frame: frame)
       loadFromNib()
       setupUI()
   }
   
   required init?(coder: NSCoder) {
       super.init(coder: coder)
       loadFromNib()
       setupUI()
   }
   
   private func loadFromNib() {
       let nib = UINib(nibName: "SearchBarView", bundle: nil)
       guard let view = nib.instantiate(withOwner: self).first as? UIView else {
           return
       }
       
       view.frame = bounds
       view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       addSubview(view)
   }

    private func setupUI() {
        textField.placeholder = "Search books..."
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .none
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        textField.leftViewMode = .always
        
        textField.addTarget(self,
                            action: #selector(textFieldDidChange),
                            for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        textPublisher.send(textField.text ?? "")
    }
}
