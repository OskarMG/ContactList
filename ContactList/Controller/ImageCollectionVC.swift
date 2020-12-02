//
//  ImageCollectionVC.swift
//  ContactList
//
//  Created by Oscar Martinez on 26/11/20.
//

import UIKit

protocol ImageCollectionVCDelegate: class {
    func didTap(image urlString: String)
}

class ImageCollectionVC: CLDataLoadingVC {
    
    enum Section { case main }
    
    //MARK: - Properties
    weak var delegate: NewContactVC!
    var imageObjects = [Image]()
    
    //MARK: - UI Elements
    let doneButton: UIButton = {
        let button = UIButton(type: .close)
        button.tintColor = Colors.claroRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var collectionView: UICollectionView!
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, Image>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCollectionView()
        configureDataSource()
        getImages()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    //MARK: - Methods
    private func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubviews(views: doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            doneButton.heightAnchor.constraint(equalToConstant: 40),
            doneButton.widthAnchor.constraint(equalToConstant: 40),
        ])
        
        doneButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    private func getImages() {
        showLoadingView()
        NetworkManager.shared.getImages { [weak self] (result) in
            guard let self = self else { return }
            switch result {
                case .success(let imageObjects):
                    self.imageObjects = imageObjects
                    self.updateData(on: imageObjects)
                    self.dismissLoadingView()
                case .failure(let error):
                    self.dismissLoadingView()
                    self.presentCLAlertOnMainThread(title: "Ups 😅", message: error.rawValue, buttonTitle: "Ok")
                    DispatchQueue.main.async { self.showEmptyStateView(in: self.view) }
            }
        }
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 4),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureDataSource() {
        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, Image>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, image) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as! ImageCell
            if let urlString = image.urls["small"] { cell.set(image: urlString) }
            return cell
        })
    }
    
    private func updateData(on imagesData: [Image]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Image>()
        snapshot.appendSections([.main])
        snapshot.appendItems(imagesData)
        DispatchQueue.main.async { self.collectionViewDataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}


//MARK: - CollectionViewDelegate
extension ImageCollectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let urlString = imageObjects[indexPath.row].urls["small"] { delegate.didTap(image: urlString) }
        dismissVC()
    }
}
