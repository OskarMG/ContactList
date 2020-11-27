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
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
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
        addSubviews(views: label, textField)
        label.textColor = Colors.absoluteBlack
        textField.textColor = Colors.absoluteBlack
        
        NSLayoutConstraint.activate([
            // textField Constrinats
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalTo: heightAnchor, constant: -21),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 5),
            
            // label Constrinats
            label.topAnchor.constraint(equalTo: textField.topAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            label.heightAnchor.constraint(equalToConstant: 14)
        
        ])
    }
}
