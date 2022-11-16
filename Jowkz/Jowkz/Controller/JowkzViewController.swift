//
//  JowkzViewController.swift
//  Jowkz
//
//  Created by Okoli-Chinedu on 16/11/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation
import UIKit

class JowkzViewController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favouriteJoke: UIButton!
    @IBOutlet weak var nextJoke: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    //MARK: Properties and Variables
    var dataController: DataController!
    
    //MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDadJokes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
        
    func downloadImage( imagePath: String, completionHandler: @escaping (_ imageDate: Data?, _ errorString: String?) -> Void) {
        let session = URLSession.shared
        let imgURL = NSURL(string: imagePath)
        let request: NSURLRequest = NSURLRequest(url: imgURL! as URL)
        
        let task = session.dataTask(with: request as URLRequest) {data, response, downloadError in
            if downloadError != nil {
                completionHandler(nil, "Could not donwload image \(imagePath)")
            }else {
                completionHandler(data, nil)
            }
        }
        task.resume()
    }
    
    func getDadJokes (){
        API.getRandomJokesFromAPI(completion: { (response, error) in
            if let downloadedJokes = response {
                let newJoke = API.getRandomImageJokes(id: downloadedJokes.id)
                self.downloadImage(imagePath: newJoke) { (data, error) in
                    self.imageView.image = UIImage(data: data!)
                }
            }
        })
    }
    
    @IBAction func addFavourite(_ sender: Any) {
    
    }
    
    @IBAction func fetchJokes(_ sender: Any){
        getDadJokes()
    }
}

