//
//  CLNewContactMessageView.swift
//  ContactList
//
//  Created by Oscar Martinez on 26/11/20.
//

import UIKit

class CLNewContactMessageView: UIView {
    
    //MARK: - UI Elements
    let imageView: UIImageView = {
        let imageView = UIImageView(image: Icons.addPersonIcon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Colors.claroRed
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let messageLabel: CLTitleLabel = {
        let title = CLTitleLabel(textAlignment: .center, fontSize: 18)
        title.text = "Add a new contact 😃"
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    init(parent: UIView) {
        super.init(frame: .zero)
        configure(parent: parent)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Methods
    private func configure(parent view: UIView) {
        view.addSubview(self)
        addSubviews(views: imageView, messageLabel)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Self View Constraints
            centerYAnchor.constraint(equalTo: view.centerYAnchor),
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            widthAnchor.constraint(equalToConstant: 200),
            heightAnchor.constraint(equalToConstant: 150),
            
            // imageView Constraints
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 125),
            imageView.heightAnchor.constraint(equalToConstant: 125),
            
            // messageLabel Constraints
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            messageLabel.widthAnchor.constraint(equalTo: widthAnchor),
            messageLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
    
}
