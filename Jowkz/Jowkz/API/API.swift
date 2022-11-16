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
        static let base = "https://icanhazdadjoke.com/j/"

        
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

    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        return task
    }

    class func getRandomJokesFromAPI (completion: @escaping (Joke?, Error?)-> Void) { taskForGETRequest(url: Endpoints.getRandomJoke.url, responseType: Joke.self) { response, error in
            if let response = response {
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getRandomImageJokes (id: String) -> String {
        let urlString = Endpoints.getPhotoJoke(id).url.absoluteString
        return urlString
    }
}
