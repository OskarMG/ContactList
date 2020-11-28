//
//  MyContactsVC.swift
//  ContactList
//
//  Created by Oscar Martinez on 25/11/20.
//

import UIKit

class MyContactsVC: UIViewController {
    
    //MARK: - Properties
    var contacts = [Contact]() {
        didSet { isContactsListEmpty() }
    }
    
    //MARK: - UI Elements
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    var editBtn: UIBarButtonItem!
    var newContactMessageView: CLNewContactMessageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        setupNavButtons()
        configureTableView()
        //contacts = fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isContactsListEmpty()
    }
    
    //MARK: - Methods
    private func configureVC() {
        title = "My Contacts"
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavButtons() {
        let addButton = UIBarButtonItem(image: Icons.addIcon, style: .plain, target: self, action: #selector(addNewContactHandler))
        editBtn = UIBarButtonItem(image: Icons.editIcon, style: .plain, target: self, action: #selector(toggleTableEdit(sender:)))
        navigationItem.rightBarButtonItems = [editBtn, addButton]
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame         = self.view.bounds
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.rowHeight     = 80
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.reuseID)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func isContactsListEmpty() {
        if contacts.count == 0 {
            tableView.setEditing(false, animated: true)
            editBtn.isEnabled = false
            navigationItem.rightBarButtonItem = editBtn
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addNewContactHandler))
            
            newContactMessageView = CLNewContactMessageView(parent: view)
            newContactMessageView.addGestureRecognizer(tapGesture)
            newContactMessageView.isUserInteractionEnabled = true
            newContactMessageView.bringSubviewToFront(view)
            return
        }
        
        editBtn.isEnabled = true
        newContactMessageView?.removeFromSuperview()
        newContactMessageView = nil
    }
    
    
    // MARK: - Events
    @objc private func addNewContactHandler() {
        let newContactVC = NewContactVC(contact: nil)
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItem = editBtn
        }
        navigationController?.pushViewController(newContactVC, animated: true)
    }
    
    @objc private func toggleTableEdit(sender: UIBarButtonItem) {
        if contacts.count != 0 {
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toggleTableEdit(sender:)))
            tableView.setEditing(!tableView.isEditing, animated: true)
            navigationItem.rightBarButtonItem = tableView.isEditing ? doneBtn : editBtn
        }
    }
}


// MARK: - UITableView Delegate and DataSource
extension MyContactsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.reuseID) as! ContactCell
        cell.set(contact: contacts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newContactVC = NewContactVC(contact: contacts[indexPath.row])
        navigationController?.pushViewController(newContactVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        contacts.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .right)
    }
}


extension MyContactsVC {
    func fetchData() -> [Contact] {
        return [
            Contact(name: "Oscar",  lastName: "Martinez",   telephone: "(829) 205-0922", imgData: nil),
            Contact(name: "Lynn",   lastName: "Martinez",   telephone: "(829) 699-2520", imgData: nil),
            Contact(name: "Zabdi",  lastName: "Gil",        telephone: "(809) 335-9921", imgData: nil),
            Contact(name: "Samuel", lastName: "David",      telephone: "(849) 305-2256", imgData: nil)
        ]
    }
}
