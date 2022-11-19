//
//  JowkzViewController.swift
//  Jowkz
//
//  Created by Okoli-Chinedu on 16/11/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class JowkzViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    //MARK: Outlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favouriteJoke: UIButton!
    @IBOutlet weak var nextJoke: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    //MARK: Properties and Variables
    var dataController: DataController!
    var photoArray: PhotoAlbum!
    var fetchedResultsController: NSFetchedResultsController<PhotoAlbum>!
    
    //MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
        self.activityIndicator.isHidden = true
        self.activityIndicator.hidesWhenStopped = true
        getDadJokes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    fileprivate func fetchResultFromCoreData () {
        let fetchRequest: NSFetchRequest<PhotoAlbum> = PhotoAlbum.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "coreID" , ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    func getDadJokes (){
        setLoading(true)
        API.getRandomJokesFromAPI(completion: { (response, error) in
            if let downloadedJokes = response {
                //Converting the Text to Pictures
                let newData = API.getRandomImageJokes(id: downloadedJokes.id)
                self.setLoading(false)
                self.downloadImage(imagePath: newData) { (data, error) in
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data!)
                    }
                }
            } else {
                self.showErrorAlert(title: "Error!", message: "No Joke Photo Found.")
            }
        })
    }
    
    func downloadImage( imagePath: String, completionHandler: @escaping (_ imageDate: Data?, _ errorString: String?) -> Void) {
        let session = URLSession.shared
        let imgURL = NSURL(string: imagePath)
        let request: NSURLRequest = NSURLRequest(url: imgURL! as URL)
        
        let task = session.dataTask(with: request as URLRequest) {data, response, downloadError in
            if downloadError != nil {
                completionHandler(nil, "Could not download image \(imagePath)")
            }else {
                completionHandler(data, nil)
            }
        }
        task.resume()
    }
    
    @IBAction func addFavourite(_ sender: Any) {
        let jokeImage = self.imageView.image
        let pngImageData = jokeImage?.pngData()
        let newPhoto = PhotoAlbum(context: self.dataController.viewContext)
        newPhoto.corePhoto = pngImageData
        try? self.dataController.viewContext.save()
    }
    
    @IBAction func fetchJokes(_ sender: Any){
        getDadJokes()
    }
    
    func showErrorAlert(title: String, message: String) {
           let alertViewController = UIAlertController (title: title,  message: message, preferredStyle: .alert)
           alertViewController.addAction(UIAlertAction(title: "Error", style: .default, handler: nil))
           self.present(alertViewController, animated: true, completion: nil)
    }
    
    // MARK: Loading state
    func setLoading(_ loading: Bool) {
        if loading {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
        self.nextJoke.isEnabled = !loading
        self.favouriteJoke.isEnabled = !loading
    }
}

