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
    
    @IBAction func refresh(_ sender: Any) {
        self.photoCollectionView.reloadData()
        (sender as! UIRefreshControl).endRefreshing()   
    }
    
    @IBAction func newCollection(_ sender: Any) {
        
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        FlickrClient.sharedInstance().getPhotos(coordinate: location) { (success, errorString) in
            if (success) {
                performUIUpdatesOnMain () {
                    self.photoCollectionView.reloadData()
                }
            }else{
                print(errorString ?? "Empty error string")
            }
        }
    }
    
    var latitude:  Double!
    var longitude: Double!
    
    let cellID = "PhotoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapSnapshot.delegate = self
        
    //    let layout = self.photoCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout
    //    layout.sectionInset = UIEdgeInsets(top: 1,left: 1,bottom: 1,right: 1)
    //    layout.headerReferenceSize = CGSize(width: 70, height: 45)
     //   layout.itemSize = CGSize(width: 100, height: 100)
        photoCollectionView?.contentMode = .scaleAspectFit
        
  //      self.photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        photoCollectionView.isHidden = false
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.refreshControl = UIRefreshControl()
        photoCollectionView.refreshControl!.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        mapSnapshot.isUserInteractionEnabled = false
        mapSnapshot.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: "sspin")
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        mapSnapshot.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapSnapshot.addAnnotation(annotation)
        
        self.photoCollectionView.reloadData()
        
        FlickrClient.sharedInstance().getPhotos(coordinate: location) { (success, errorString) in
            if (success) {
                performUIUpdatesOnMain () {
                    self.photoCollectionView.reloadData()
                }
            }else{
                print(errorString ?? "Empty error string")
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
            pinView!.pinTintColor = .red
        }else{
            pinView!.annotation = annotation
            pinView!.canShowCallout = false
            pinView!.animatesDrop = true
            pinView!.pinTintColor = .red
        }
        
        return pinView
    }
}

extension PhotosViewController  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAlbum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let CellID = "PhotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath) as! PhotoCollectionViewCell
        
        let photo = photoAlbum[(indexPath as NSIndexPath).row]

        if (photo.image == nil) {
            spinner?.show(v: cell.photoImageView as UIView)
            
        }else{

            cell.photoImageView?.image = photo.image
            cell.isHidden = false
        }
        return cell
    }
    
}
