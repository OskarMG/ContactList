//
//  Contact.swift
//  ContactList
//
//  Created by Oscar Martinez on 26/11/20.
//

import Foundation

struct Contact: Codable, Hashable {
    var identifier = UUID()
    var name:      String!
    var lastName:  String!
    var telephone: String!
    var imgData:   Data?
}
