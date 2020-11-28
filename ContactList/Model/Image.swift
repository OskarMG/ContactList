//
//  Image.swift
//  ContactList
//
//  Created by Oscar Martinez on 27/11/20.
//

import Foundation

struct Image: Codable, Hashable {
    var id: String
    var urls: [String : String]
}
