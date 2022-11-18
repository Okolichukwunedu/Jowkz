//
//  API.swift
//  Jowkz
//
//  Created by Okoli-Chinedu on 16/11/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class API {
    
    enum Endpoints {
        static let base = "https://icanhazdadjoke.com/"

        case getRandomJoke
        case getPhotoJoke(String)
      
        var stringValue: String {
            switch self {
            case .getRandomJoke:
                return Endpoints.base
            case .getPhotoJoke(let id):
                return Endpoints.base + "\(id).png"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getRandomJokesFromAPI (completion: @escaping (Joke?, Error?)-> Void) {

        var request = URLRequest(url: Endpoints.getRandomJoke.url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
                
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
                
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(Joke.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
            }catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func getRandomImageJokes (id: String) -> String {
        let urlString = Endpoints.getPhotoJoke(id).url.absoluteString
        return urlString
    }
}
