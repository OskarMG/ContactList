//
//  MainContactListNC.swift
//  ContactList
//
//  Created by Oscar Martinez on 25/11/20.
//

import UIKit

class MainContactListNC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewControllers = [createMyContactsVC()]
    }
    
    // Configure Main Contact List Navigation Controller
    private func configure() {
        UINavigationBar.appearance().tintColor = Colors.claroRed
    }
    
    
    // Creates MyContacts View Controller
    private func createMyContactsVC () -> UIViewController {
        return MyContactsVC()
    }

}
