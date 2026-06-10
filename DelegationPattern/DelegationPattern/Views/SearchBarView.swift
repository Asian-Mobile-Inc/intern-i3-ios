//
//  SearchBarView.swift
//  DelegationPattern
//
//  Created by Văn Tiến on 04/05/2026.
//

import UIKit

class SearchBarView: UIView {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    
    weak var delegate: SearchBarViewDelegate?
    
    override init(frame: CGRect) {
       super.init(frame: frame)
       commonInit()
   }

   required init?(coder: NSCoder) {
       super.init(coder: coder)
       commonInit()
   }

    func commonInit(){
        let nib = UINib(nibName: "SearchBarView", bundle: .main)
        let contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        searchTextField.delegate = self  // UITextFieldDelegate
        clearButton.isHidden = true
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = .systemGray6
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
       searchTextField.text = ""
       clearButton.isHidden = true
//       searchTextField.resignFirstResponder()
       delegate?.searchBarView(self, didChangeText: "")
    }
    
}

extension SearchBarView : UITextFieldDelegate {
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else {return true}
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        clearButton.isHidden = newText.isEmpty
        
        delegate?.searchBarView(self, didChangeText: newText)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
   }

   func textFieldDidBeginEditing(_ textField: UITextField) {
       delegate?.searchBarViewDidBeginEditing?(self)
   }
}

@objc protocol SearchBarViewDelegate: AnyObject {
    func searchBarView(_ view: SearchBarView, didChangeText text: String)
    
    @objc optional func searchBarViewDidBeginEditing(_ view: SearchBarView)
}

