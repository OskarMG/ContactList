//
//  NetworkManager.swift
//  ContactList
//
//  Created by Oscar Martinez on 26/11/20.
//

import UIKit


class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = ""
    private init() {}
    
    func getImages() {
        
    }
    
    func downloadImage(from urlString: String, completed: @escaping(Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil,
                let reponse = response as? HTTPURLResponse, reponse.statusCode == 200,
                let data = data else {
                    completed(nil)
                    return
                }
            DispatchQueue.main.async { completed(data) }
        }
        task.resume()
    }
}
