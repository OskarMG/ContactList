//
//  ContactListTests.swift
//  ContactListTests
//
//  Created by Oscar Martinez on 30/11/20.
//

import XCTest
@testable import ContactList

class ContactListTests: XCTestCase {
    
    //MARK: - Unit Tests Implementation: test Form Labels, Telephone Length, Persistence Manager Action Types and NetworkManager

    func testFormLabels() {
        let formLabels: [FormLabels : String] = [
            FormLabels.name: FormLabels.name.rawValue,
            FormLabels.lastName: FormLabels.lastName.rawValue,
            FormLabels.telephone : FormLabels.telephone.rawValue
        ]
        
        let labels: [FormLabels : String] = [
            .name : "Name",
            .lastName : "Last name",
            .telephone : "Telephone"
        ]
        
        XCTAssertEqual(formLabels, labels)
    }
    
    func testTelephoneLength() {
        let telephone = "8292050922"
        let formattedTelephone = telephone.formatToPhone()
        XCTAssertEqual(formattedTelephone, "(829) 205-0922")
    }
    
    func testPersistenceManager() {
        var contactUUID: UUID?
        
        let contacts = [Contact(identifier: UUID(), name: "Unit", lastName: "Test", telephone: "(000 000-0000)", imgData: nil)]
        let error: CLError? = PersistenceManager.save(contact: contacts)
        XCTAssertNil(error)
        
        var contact = contacts.first!
        contact.name += " Jr"
        contactUUID = contact.identifier
        
        PersistenceManager.update(contact: contact, actionType: .update) { error in
            XCTAssertNil(error)
        }
        
        PersistenceManager.retriveContacts { result in
            switch result {
                case .success(let contacts):
                    let contactEdited: [Contact] = contacts.filter { contact -> Bool in
                        return contact.identifier == contactUUID
                    }
                    XCTAssertEqual(contactEdited.first!.name, "Unit Jr")
                case .failure(_): break
            }
        }
    }
    
    func testNetworkManager() {
        NetworkManager.shared.getImages { (result) in
            switch result {
                case .success(_): break
                case .failure(let error):
                    XCTAssertNil(error)
            }
        }
    }
}
