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
    private let baseUrl = "https://api.unsplash.com/photos/random/?count=20&client_id="
    private init() {}
    
    func getImages(completed: @escaping([Image]?)->Void) {
        let urlString = "\(baseUrl)" + key
        guard let url = URL(string: urlString) else {
            completed(nil)
            print("invalid URL API or not available")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
            guard error == nil else {
                completed(nil)
                print(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil)
                print("no connection")
                return
            }
            
            guard let data = data else {
                completed(nil)
                print("invalid data")
                return
            }
        
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let images = try decoder.decode([Image].self, from: data)
                completed(images)
            } catch {
                completed(nil)
                print(error.localizedDescription)
                return
            }
        }
        
        task.resume()
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
