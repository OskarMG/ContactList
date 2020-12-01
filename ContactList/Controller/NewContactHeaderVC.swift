//
//  NewContactHeaderVC.swift
//  ContactList
//
//  Created by Oscar Martinez on 26/11/20.
//

import UIKit

protocol NewContactHeaderVCDelegate: class {
    func didLoadImageButtonTapped()
}

class NewContactHeaderVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: NewContactVC!
    
    //MARK: - UI Elements
    let imageView = CLContactImageView(frame: .zero)
    let loadImage = CLSmallButton(type: .system)
    
    init(imageData: Data?, delegate: NewContactVC) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.setup(image: imageData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        delegate.delegate = self
    }
    

    //MARK: - Methods
    private func configureVC() {
        view.backgroundColor = .clear
        view.addSubviews(views: imageView, loadImage)
        
        let imageViewSizeWH: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 150 : 170
    
        NSLayoutConstraint.activate([
            // imageView Constraints
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageViewSizeWH),
            imageView.heightAnchor.constraint(equalToConstant: imageViewSizeWH),
            
            // save Constraints
            loadImage.widthAnchor.constraint(equalTo: imageView.widthAnchor, constant: -20),
            loadImage.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            loadImage.heightAnchor.constraint(equalToConstant: 40),
            loadImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ])
        
        loadImage.addTarget(self, action: #selector(loadImageButtonHandler), for: .touchUpInside)
    }
    
    private func setup(image data: Data?) {
        guard let data = data else { return }
        DispatchQueue.main.async { self.imageView.image = UIImage(data: data) }
    }
    
    
    //MARK: - Events
    @objc private func loadImageButtonHandler() {
        delegate?.didLoadImageButtonTapped()
    }
}
