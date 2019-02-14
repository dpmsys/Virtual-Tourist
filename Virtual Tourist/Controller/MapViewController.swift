//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by David Mulvihill on 2/7/19.
//  Copyright © 2019 David Mulvihill. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
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
 //       setupFetchedResultsController()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onMapLongPressed))
        longPressRecognizer.delegate = self
        tourMap.addGestureRecognizer(longPressRecognizer)
        
        let fetchRequest:NSFetchRequest<Location> = Location.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "latitude", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            locations = result
        }
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = location.latitude
            annotation.coordinate.longitude = location.longitude
            tourMap.addAnnotation(annotation)
        }
        
        // if we've save a map view before restore it
        
        if UserDefaults.standard.value(forKey: "mapCenterLat") != nil {
            var center = CLLocationCoordinate2D()
            center.latitude = UserDefaults.standard.value(forKey: "mapCenterLat") as! CLLocationDegrees
            center.longitude = UserDefaults.standard.value(forKey: "mapCenterLong") as! CLLocationDegrees
            
            var span = MKCoordinateSpan()
            span.latitudeDelta = UserDefaults.standard.value(forKey: "mapLatDelta") as! CLLocationDegrees
            span.longitudeDelta = UserDefaults.standard.value(forKey: "mapLongDelta") as! CLLocationDegrees
            let region = MKCoordinateRegion(center: center, span: span)
            tourMap.setRegion(region, animated: true)
        }
    }

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

            let location = Location(context: dataController.viewContext)
            location.latitude = locCoordinate.latitude
            location.longitude = locCoordinate.longitude
            try! dataController.viewContext.save()
            
 //           FlickrClient.sharedInstance().getPhotos(coordinate: locCoordinate) { (success, errorString) in
  //              if (success) {
                    
 //               }else{
 //                   print(errorString)
 //               }
 //           }
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
        // save view to user defaults
        
        UserDefaults.standard.set(mapView.region.center.latitude, forKey: "mapCenterLat")
        UserDefaults.standard.set(mapView.region.center.longitude, forKey: "mapCenterLong")
        UserDefaults.standard.set(mapView.region.span.latitudeDelta, forKey: "mapLatDelta")
        UserDefaults.standard.set(mapView.region.span.longitudeDelta, forKey: "mapLongDelta")
        UserDefaults.standard.set(mapView.camera.altitude, forKey: "mapAltitude")
    }
}



extension MapViewController {
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

