//
//  PhotosViewController.swift
//  Virtual Tourist
//
//  Created by David Mulvihill on 2/9/19.
//  Copyright © 2019 David Mulvihill. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
    @IBOutlet weak var mapSnapshot: MKMapView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var latitude:  Double!
    var longitude: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapSnapshot.isUserInteractionEnabled = false
        
        print(latitude)
        print(longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region = MKCoordinateRegion(center: location, span: span)
        mapSnapshot.setRegion(region, animated: false)
    }
    
}

extension PhotosViewController  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAlbum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let CellID = "PhotoCollectionCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath) as! PhotoCollectionViewCell
        
        let photo = photoAlbum[(indexPath as NSIndexPath).row]
        cell.photoImageView?.image = photo.image
        
        return cell
    }
    
}
