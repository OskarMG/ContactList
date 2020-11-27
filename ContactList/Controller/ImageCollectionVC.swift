//
//  ImageCollectionVC.swift
//  ContactList
//
//  Created by Oscar Martinez on 26/11/20.
//

import UIKit

class ImageCollectionVC: UIViewController {
    
    //MARK: - Properties
    var imageCollection = [UIImage]()
    
    //MARK: - UI Elements
    let doneButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    

    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubviews(views: doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            doneButton.heightAnchor.constraint(equalToConstant: 40),
            doneButton.widthAnchor.constraint(equalToConstant: 40),
        ])
        
        doneButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }

}
