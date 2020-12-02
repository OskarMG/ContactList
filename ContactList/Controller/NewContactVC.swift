//
//  NewContactVC.swift
//  ContactList
//
//  Created by Oscar Martinez on 25/11/20.
//

import UIKit

protocol HeaderVCDelegate: class {
    func set(image urlString: String)
}

class NewContactVC: UIViewController {
    
    //MARK: - Properties
    var contact: Contact!
    var formTopConstraint: NSLayoutConstraint!
    weak var delegate: NewContactHeaderVC!
    var isEditingContact = false
    
    let textFieldViews = [
        CLTextFieldView(textLabel: FormLabels.name.rawValue, placeHolder: "Oscar"),
        CLTextFieldView(textLabel: FormLabels.lastName.rawValue, placeHolder: "Martinez"),
        CLTextFieldView(textLabel: FormLabels.telephone.rawValue, placeHolder: "(###) ###-####")
    ]
    
    //MARK: - UI Elements
    let headerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        return view
    }()

    lazy var formStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: self.textFieldViews)
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = Colors.absoluteWhite
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let saveBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.claroRed
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(contact: Contact) {
        super.init(nibName: nil, bundle: nil)
        self.contact = contact
        configureVC()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        setupNavButtons()
        configureTextFields()
        setupUIElements()
        setupFields()
        view.createDismissKBGesture()
    }
    
    //MARK: - Methods
    private func configureVC() {
        title = "New Contact"
        view.backgroundColor = .lightGray
        navigationItem.hidesBackButton = true
    }
    
    private func scrollTo(element tag: Int, reset: Bool) {
        guard !reset else {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.formTopConstraint.constant = CGFloat(10)
                self.view.layoutIfNeeded()
            }
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            switch (tag) {
                case 1: self.formTopConstraint.constant  = CGFloat(-65)
                case 2: self.formTopConstraint.constant  = CGFloat(-60 * 2)
                default: self.formTopConstraint.constant = CGFloat(10)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupNavButtons() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeHandler))
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    private func configureTextFields() {
        for (index, textFieldView) in textFieldViews.enumerated() {
            textFieldView.textField.tag = index
            textFieldView.textField.delegate = self
            if index == 2 { textFieldView.textField.keyboardType = .phonePad }
        }
    } 
    
    private func setupUIElements() {
        view.addSubviews(views: headerView, formStack, saveBtn)
        
        let headerViewSizeH: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 230 : 250
        let padding: CGFloat = 20
        
        formTopConstraint = formStack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10)
        formTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            // headerView Constraints
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerViewSizeH),
            
            // tableView form Constraints
            formStack.widthAnchor.constraint(equalTo: view.widthAnchor),
            formStack.heightAnchor.constraint(equalToConstant: 200),
            
            // saveButton Constraints
            saveBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            saveBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            saveBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            saveBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.sendSubviewToBack(formStack)
        saveBtn.addTarget(self, action: #selector(saveContact), for: .touchUpInside)
    }
    
    
    private func setupFields() {
        if contact.name != nil { title = "\(contact.name!) " + contact.lastName }
        add(childVC: NewContactHeaderVC(imageData: contact.imgData, delegate: self), to: headerView)
        textFieldViews[0].textField.text = contact.name
        textFieldViews[1].textField.text = contact.lastName
        textFieldViews[2].textField.text = contact.telephone?.formatToPhone()
    }
    
    
    //MARK: - Events
    @objc private func closeHandler() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveContact() {
        guard let name = textFieldViews[0].textField.text, !name.isEmpty, !name.isWhitespace(),
              let lastName = textFieldViews[1].textField.text, !lastName.isEmpty, !lastName.isWhitespace(),
              let telephone = textFieldViews[2].textField.text, !telephone.isEmpty else {
            presentCLAlertOnMainThread(title: "Ups 😅", message: CLError.completeFields.rawValue, buttonTitle: "Ok")
            return
        }
        
        guard telephone.count == 14 else {
            presentCLAlertOnMainThread(title: "Invalid Telephone", message: CLError.invalidTelephone.rawValue, buttonTitle: "Ok")
            return
        }
        
        self.contact.name = name
        self.contact.lastName = lastName
        self.contact.telephone = telephone
        
        PersistenceManager.update(contact: self.contact, actionType: isEditingContact ? .update : .add) {[weak self] (error) in
            guard let self = self else { return }
            self.closeHandler()
            guard let error = error else { return }
            self.presentCLAlertOnMainThread(title: "Ups something wen't wrong", message: error.rawValue, buttonTitle: "Ok")
        }
        
    }
}




//MARK: - NewContactHeaderVCDelegate
extension NewContactVC: NewContactHeaderVCDelegate {
    func didLoadImageButtonTapped() {
        let imageCollectionVC = ImageCollectionVC()
        imageCollectionVC.delegate = self
        imageCollectionVC.modalPresentationStyle  = .pageSheet
        imageCollectionVC.modalTransitionStyle    = .coverVertical
        DispatchQueue.main.async { self.present(imageCollectionVC, animated: true) }
    }
}


//MARK: - ImageCollectionVCDelegate
extension NewContactVC: ImageCollectionVCDelegate {
    func didTap(image urlString: String) {
        self.delegate.imageView.downloadImage(from: urlString) {[weak self] (data) in
            guard let self = self else { return }
            self.contact.imgData = data
        }
    }
}

//MARK - UITextFieldDelegate
extension NewContactVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollTo(element: textField.tag, reset: false)
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollTo(element: textField.tag, reset: true)
        switch textField.tag {
            case 0: contact.name = textField.text
            case 1: contact.lastName = textField.text
            case 2: contact.telephone = textField.text
            default: break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 2 {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = newString.formatToPhone()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
