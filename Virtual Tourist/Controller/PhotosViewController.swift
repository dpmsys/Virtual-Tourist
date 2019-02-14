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

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate {
  
    @IBOutlet weak var mapSnapshot: MKMapView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var latitude:  Double!
    var longitude: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapSnapshot.delegate = self
        mapSnapshot.isUserInteractionEnabled = false
        mapSnapshot.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: "sspin")
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        mapSnapshot.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapSnapshot.addAnnotation(annotation)
        
        FlickrClient.sharedInstance().getPhotos(coordinate: location) { (success, errorString) in
            if (success) {
            
            }else{
                print(errorString)
            }
        }
        
        
    }
    
}

extension PhotosViewController {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView: MKPinAnnotationView!
        let reuseId = "sspin"
        
        pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId, for: annotation) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.animatesDrop = true
            pinView!.pinTintColor = .green
        }else{
            pinView!.annotation = annotation
            pinView!.canShowCallout = false
            pinView!.animatesDrop = true
            pinView!.pinTintColor = .green
        }
        
        return pinView
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
