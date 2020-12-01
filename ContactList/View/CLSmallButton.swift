//
//  CLSmallButton.swift
//  ContactList
//
//  Created by Oscar Martinez on 29/11/20.
//

import UIKit

class CLSmallButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Methods
    private func configure() {
        setTitle("Upload image", for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = Colors.claroRed
        layer.cornerRadius = 20
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }

}
