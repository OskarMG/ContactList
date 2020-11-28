//
//  NetworkManager.swift
//  ContactList
//
//  Created by Oscar Martinez on 26/11/20.
//

import UIKit


class NetworkManager {
    static let shared = NetworkManager()
    private let key = "rKKtzg9vxdYjJOWjCDWRCU_ArVOFCyEBqnEFobjCJ7g"
    private let baseUrl = "https://api.unsplash.com/photos/random/?count=30&client_id="
    private init() {}
    
    func getImages(completed: @escaping(Result<[Image], CLError>) -> Void) {
        
        let urlString = "\(baseUrl)" + key
        
        guard let url = URL(string: urlString) else {
            completed(.failure(.apiUnavailable))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completed(.failure(.unavailableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
        
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let images = try decoder.decode([Image].self, from: data)
                completed(.success(images))
            } catch {
                completed(.failure(.apiUnavailable))
                return
            }
        }
        
        task.resume()
    }
}
