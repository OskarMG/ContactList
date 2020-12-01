//
//  ContactCell.swift
//  ContactList
//
//  Created by Oscar Martinez on 25/11/20.
//

import UIKit

class ContactCell: UITableViewCell {
    
    //MARK: - Properties
    static let reuseID = "ContactCell"
    
    //MARK: - UI Elements
    var thumbnail       = CLContactImageView(frame: .zero)
    var contactName     = CLTitleLabel(textAlignment: .left, fontSize: 18)
    var contactNumber   = CLBodyLabel(textAlignment: .left)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Methods
    private func configure() {
        addSubviews(views: thumbnail, contactName, contactNumber)
        
        let padding: CGFloat = 20
        
        let arrow = UIImageView(image: Icons.rightArrowIcon)
        arrow.tintColor   = .systemGreen
        arrow.contentMode = .scaleAspectFit
        
        accessoryView = arrow
        
        NSLayoutConstraint.activate([
            // thumbnail constraints
            thumbnail.centerYAnchor.constraint(equalTo: centerYAnchor),
            thumbnail.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            thumbnail.widthAnchor.constraint(equalToConstant: 60),
            thumbnail.heightAnchor.constraint(equalToConstant: 60),
            
            // contactName constraints
            contactName.centerYAnchor.constraint(equalTo: thumbnail.centerYAnchor, constant: -padding/1.5),
            contactName.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: padding),
            contactName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            contactName.heightAnchor.constraint(equalToConstant: 20),
            
            // contactNumber constraints
            contactNumber.centerYAnchor.constraint(equalTo: thumbnail.centerYAnchor, constant: padding/1.5),
            contactNumber.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: padding),
            contactNumber.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            contactNumber.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func set(contact: Contact) {
        contactName.text    = "\(contact.name!) " + contact.lastName
        contactNumber.text  = contact.telephone
        
        guard let imageData = contact.imgData else {
            DispatchQueue.main.async { self.thumbnail.image = Images.defaultPhoto }
            return
        }
        DispatchQueue.main.async { self.thumbnail.image = UIImage(data: imageData) }
    }
    
}
