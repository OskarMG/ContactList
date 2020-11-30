//
//  MyContactsVC.swift
//  ContactList
//
//  Created by Oscar Martinez on 25/11/20.
//

import UIKit

class MyContactsVC: UIViewController {
    
    //MARK: - Properties
    var isSearching      = false
    var contacts         = [Contact]()
    var filteredContacts = [Contact]()
    
    
    var numberOfRowInSection: Int {
        get { isSearching ? filteredContacts.count : contacts.count }
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
        configureSearchController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshContacts()
    }
    
    //MARK: - Methods
    private func configureVC() {
        title = "My Contacts"
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavButtons() {
        let addButton = UIBarButtonItem(image: Icons.addIcon, style: .plain, target: self, action: #selector(pushToNewContactVC))
        editBtn = UIBarButtonItem(image: Icons.editIcon, style: .plain, target: self, action: #selector(toggleTableEdit(sender:)))
        navigationItem.rightBarButtonItems = [editBtn, addButton]
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater   = self
        searchController.searchBar.delegate     = self
        searchController.searchBar.placeholder  = "Search contact"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController         = searchController
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
            tableView.isScrollEnabled = false
            tableView.setEditing(false, animated: true)
            editBtn.isEnabled = false
            navigationItem.rightBarButtonItem = editBtn
            navigationItem.searchController?.searchBar.searchTextField.isEnabled = false
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pushToNewContactVC))
            
            newContactMessageView = CLNewContactMessageView(parent: view)
            newContactMessageView.addGestureRecognizer(tapGesture)
            newContactMessageView.isUserInteractionEnabled = true
            newContactMessageView.bringSubviewToFront(view)
            return
        }
        
        editBtn.isEnabled = true
        tableView.isScrollEnabled = true
        newContactMessageView?.removeFromSuperview()
        newContactMessageView = nil
        navigationItem.searchController?.searchBar.searchTextField.isEnabled = true
    }
    
    private func refreshContacts() {
        PersistenceManager.retriveContacts {[weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let contacts):
                self.contacts = contacts
                DispatchQueue.main.async { self.tableView.reloadData() }
            case .failure(let error):
                self.presentCLAlertOnMainThread(title: "Ups something wen't wrong 😅", message: error.rawValue, buttonTitle: "Ok")
            }
            
            self.isContactsListEmpty()
        }
    }
    
    
    // MARK: - Events
    @objc private func pushToNewContactVC() {
        let newContactVC = NewContactVC(contact: Contact())
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
        return numberOfRowInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.reuseID) as! ContactCell
        let activeArray = isSearching ? filteredContacts : contacts
        let contact = activeArray[indexPath.row]
        cell.set(contact: contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let activeArray = isSearching ? filteredContacts : contacts
        let newContactVC = NewContactVC(contact: activeArray[indexPath.row])
        newContactVC.isEditingContact = true
        navigationController?.pushViewController(newContactVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        tableView.isEditing ? UITableViewCell.EditingStyle.delete : UITableViewCell.EditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        var contact: Contact!
        
        switch isSearching {
            case true:
                contact = filteredContacts[indexPath.row]
                filteredContacts.remove(at: indexPath.row)
            case false:
                contact = contacts[indexPath.row]
                contacts.remove(at: indexPath.row)
        }
        
        tableView.deleteRows(at: [indexPath], with: .left)
        guard contact != nil else { return }
        
        PersistenceManager.update(contact: contact, actionType: .remove) {[weak self] (error) in
            guard let self = self else { return }
            guard let error = error else {
                self.refreshContacts()
                return
            }
            self.presentCLAlertOnMainThread(title: "Ups something wen't wrong 😅", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}


//MARK: - SearchBar Delegate
extension MyContactsVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredContacts = contacts.filter { "\($0.name.lowercased())\($0.lastName.lowercased())\($0.telephone!)".contains(filter.lowercased()) }
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        refreshContacts()
    }
}


// testing data
extension MyContactsVC {
    func fetchData() -> [Contact] {
        return [
            Contact(name: "Oscar",  lastName: "Martinez",   telephone: "(829) 205-0922", imgData: nil),
            Contact(name: "Lynn",   lastName: "Martinez",   telephone: "(829) 699-2520", imgData: nil),
            Contact(name: "Ingeniero", lastName: "Plato",   telephone: "(809) 335-9921", imgData: nil),
            Contact(name: "Samuel", lastName: "David",      telephone: "(849) 305-2256", imgData: nil)
        ]
    }
}
