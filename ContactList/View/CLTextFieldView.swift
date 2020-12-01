//
//  CLTextFieldView.swift
//  ContactList
//
//  Created by Oscar Martinez on 26/11/20.
//

import UIKit

class CLTextFieldView: UIView {

    //MARK: - UI Elements
    let label = CLTitleLabel(textAlignment: .left, fontSize: 14)
    let textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    convenience init(textLabel: String, placeHolder: String) {
        self.init(frame: .zero)
        label.text = textLabel
        textField.placeholder = placeHolder
        textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray.withAlphaComponent(0.7)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Methdos
    private func configure() {
        addSubviews(views:label, textField)
        label.textColor = Colors.absoluteBlack
        textField.textColor = Colors.absoluteBlack

        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            // textField Constrinats
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            textField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            
            // label Constrinats
            label.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2)
        ])
    }
}
