import UIKit

class ListViewController: UIViewController {

    let stackView = UIStackView()
    let addButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupStackView()
        setupFloatingButton()
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupFloatingButton() {
        addButton.setTitle("Thêm Thẻ", for: .normal)
        addButton.backgroundColor = .systemBlue
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 25
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.addTarget(self, action: #selector(addNewCard), for: .touchUpInside)
        
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 120),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension ListViewController {
    
    @objc private func addNewCard() {
        let newCard = CardView.loadFromNib()
        newCard.iconImageView.image = UIImage(systemName: "star.fill")
        
        newCard.onDeleteTapped = { [weak self, weak newCard] in
            print("tapped")
            guard let self = self, let cardToRemove = newCard else { return }
            
            UIView.animate(withDuration: 0.3, animations: {
                cardToRemove.isHidden = true
            }) { _ in
                cardToRemove.removeFromSuperview()
            }
        }

        newCard.isHidden = true
        stackView.addArrangedSubview(newCard)
        
        UIView.animate(withDuration: 0.3) {
            newCard.isHidden = false
        }
    }
}

