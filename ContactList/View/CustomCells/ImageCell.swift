//
//  ImageCell.swift
//  ContactList
//
//  Created by Oscar Martinez on 27/11/20.
//

import UIKit

protocol ImageCellDelegate: class {
    func downloaded(image data: Data)
}

class ImageCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let reuseID = "ImageCell"
    let avatarImageView = CLContactImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Methods
    func set(image urlString: String) {
        avatarImageView.downloadImage(from: urlString)
    }
    
    private func configure() {
        addSubview(avatarImageView)
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo:       contentView.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo:   contentView.leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor),
            avatarImageView.heightAnchor.constraint(equalTo:    contentView.heightAnchor)
        ])
    }
}
