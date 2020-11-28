//
//  CLContactImageView.swift
//  ContactList
//
//  Created by Oscar Martinez on 25/11/20.
//

import UIKit

class CLContactImageView: UIImageView {
    
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
    
    
    func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async { self.image = image }
        }
        
        task.resume()
    }
}
