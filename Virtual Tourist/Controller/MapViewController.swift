//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by David Mulvihill on 2/7/19.
//  Copyright © 2019 David Mulvihill. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MapViewController:  UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate {


    
    @IBOutlet weak var tourMap: MKMapView!
    
    var dataController: DataController!
    var fetchedResultsController:NSFetchedResultsController<Location>!
    
    fileprivate func setupFetchedResultsController() {
        
        let fetchRequest:NSFetchRequest<Location> = Location.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "latitude", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "locations")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tourMap.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: "pin")
        setupFetchedResultsController()
        
 //       let clickRecognizer = UITapGestureRecognizer(target: self, action: #selector(onMapClicked))
  //      clickRecognizer.delegate = self
 //       tourMap.addGestureRecognizer(clickRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onMapLongPressed))
        longPressRecognizer.delegate = self
        tourMap.addGestureRecognizer(longPressRecognizer)
        
        
    }
    
//    @objc func onMapClicked() {
//        print("map tapped")
//    }

    @objc func onMapLongPressed (_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            print("drop pin")
            
            let touchLocation = sender.location(in: tourMap)
            let locCoordinate = tourMap.convert(touchLocation,toCoordinateFrom: tourMap)
            print("Tapped at lat: \(locCoordinate.latitude) long: \(locCoordinate.longitude)")
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = locCoordinate
            annotations.append(annotation)
            tourMap.addAnnotation(annotation)
            
 //           FlickrClient.sharedInstance().getPhotos(coordinate: locCoordinate) { (success, errorString) in
  //              if (success) {
                    
 //               }else{
 //                   print(errorString)
 //               }
 //           }
            return
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        var photosVC = PhotosViewController()
        print("pin tapped")
       
        photosVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
        photosVC.latitude = view.annotation?.coordinate.latitude
        photosVC.longitude = view.annotation?.coordinate.longitude
        self.present(photosVC, animated: true, completion: nil)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView: MKPinAnnotationView!
        let reuseId = "pin"
        
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

