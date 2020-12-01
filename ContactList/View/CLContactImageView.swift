//
//  CLContactImageView.swift
//  ContactList
//
//  Created by Oscar Martinez on 25/11/20.
//

import UIKit

class CLContactImageView: UIImageView {
    
    //MARK: - Properties
    let placeHolderImage = Images.defaultPhoto

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius  = 5
        clipsToBounds       = true
        image               = placeHolderImage
        contentMode         = .scaleAspectFill
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func downloadImage(from urlString: String, completion: ((Data?)->Void)? = nil) {
        NetworkManager.shared.downloadImage(from: urlString) {[weak self] (data) in
            guard let self = self, let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                completion?(data)
            }
        }
    }
    
}
