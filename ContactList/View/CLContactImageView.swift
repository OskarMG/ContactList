//
//  CLContactImageView.swift
//  ContactList
//
//  Created by Oscar Martinez on 25/11/20.
//

import UIKit

class CLContactImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func configure() {
        image = Images.defaultPhoto
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = 5
        translatesAutoresizingMaskIntoConstraints = false
    }
}
