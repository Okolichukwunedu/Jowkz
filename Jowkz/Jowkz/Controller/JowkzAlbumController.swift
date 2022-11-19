//
//  JowkzAlbumController.swift
//  Jowkz
//
//  Created by Okoli-Chinedu on 16/11/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class JowkzAlbumController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    //MARK: Outlet
    @IBOutlet weak var collectionPhotoView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var label: UILabel!
    //MARK: Properties and Variables
    var dataController: DataController!
    var photoArray: PhotoAlbum!
    var fetchedResultsController: NSFetchedResultsController<PhotoAlbum>!
 
    //MARK: Life Cylcles
    override func viewDidLoad () {
        super.viewDidLoad()
        
        collectionPhotoView.delegate = self
        flowLayoutSet()
        fetchResultFromCoreData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    fileprivate func flowLayoutSet() {
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let _ = (view.frame.size.height - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        collectionPhotoView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    fileprivate func fetchResultFromCoreData () {
        let fetchRequest: NSFetchRequest<PhotoAlbum> = PhotoAlbum.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "coreURL" , ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
}

extension JowkzAlbumController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fetchResultFromCoreData()
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCell
        let cellImage = fetchedResultsController.fetchedObjects![indexPath.row]
        if cellImage.corePhoto != nil {
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(data: cellImage.corePhoto!)
            }
        } else {
            cell.imageView.image = UIImage(systemName: "noImage")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Select the image view from the core data at indexPath and delete it
        let deleteImage = fetchedResultsController.object(at: indexPath)
        self.dataController.viewContext.delete(deleteImage)
        //Remove the cell for the collection view
        try? dataController.viewContext.save()
        self.collectionPhotoView.reloadData()
    }
}
