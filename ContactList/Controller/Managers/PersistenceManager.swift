//
//  PersistenceManager.swift
//  ContactList
//
//  Created by Oscar Martinez on 29/11/20.
//

import UIKit

enum PersistenceType {
    case add, remove, update
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let contacts = "contacts"
    }
    
    static func update(contact: Contact, actionType: PersistenceType, completed: @escaping(CLError?)->Void) {
        retriveContacts { result in
            switch result {
                case .success(let contacts):
                    var retrivedContacts = contacts
                    
                    switch actionType {
                    case .add:
                        guard !retrivedContacts.contains(contact) else {
                            completed(.contactAlreadyExists)
                            return
                        }
                        retrivedContacts.append(contact)
                    case .update:
                        for (index, c) in retrivedContacts.enumerated() {
                            if c.identifier == contact.identifier {
                                retrivedContacts[index].name = contact.name
                                retrivedContacts[index].lastName = contact.lastName
                                retrivedContacts[index].imgData = contact.imgData
                            }
                        }
                    case .remove: retrivedContacts.removeAll { $0.identifier == contact.identifier } }
                    
                    completed(save(contact: retrivedContacts))
                    
                case .failure(let error):
                    completed(error)
            }
        }
    }
    
    static func retriveContacts(completed: @escaping(Result<[Contact], CLError>)->Void) {
        guard let contactData = defaults.object(forKey: Keys.contacts) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let contacts = try decoder.decode([Contact].self, from: contactData)
            completed(.success(contacts))
        } catch {
            completed(.failure(.couldNotRetriveData))
        }
    }
    
    static func save(contact: [Contact]) -> CLError? {
        do {
            let coder = JSONEncoder()
            let contact = try coder.encode(contact)
            defaults.set(contact, forKey: Keys.contacts)
            return nil
        } catch { return .couldNotSave }
    }
    
}
