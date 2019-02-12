//
//  FlickrConvenience.swift
//  Virtual Tourist
//
//  Created by David Mulvihill on 2/9/19.
//  Copyright © 2019 David Mulvihill. All rights reserved.
//

import Foundation
import MapKit

extension FlickrClient {
    
    func getPhotos(coordinate: CLLocationCoordinate2D,_ completionHandlerForGetPhotos: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        var parameters = [String:AnyObject] ()
        
        parameters[FlickrClient.ParameterKeys.APIKey] = FlickrClient.Constants.APIKey as AnyObject
        parameters[FlickrClient.ParameterKeys.Format] = FlickrClient.Constants.Format as AnyObject
        parameters[FlickrClient.ParameterKeys.Latitude] = coordinate.latitude as AnyObject
        parameters[FlickrClient.ParameterKeys.Longitude] = coordinate.longitude as AnyObject
        parameters[FlickrClient.ParameterKeys.Radius] = FlickrClient.Constants.SearchRadius as AnyObject
        parameters[FlickrClient.ParameterKeys.PerPage] = 21 as AnyObject
        
        let urlstr: String = FlickrClient.Methods.Search
        
        let _ = taskForGETMethod(urlstr, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            if error != nil {
                completionHandlerForGetPhotos(false, "Get photos failed")
            } else {
                if let photos = results?[FlickrClient.JSONResponseKeys.Photos] as! Dictionary<String, Any>? {
                    if let photoArray = photos["photo"] as! [Dictionary<String, Any>]? {
                        for photo in photoArray {
                            let url1 = "https://farm" + String(photo["farm"] as! Int) + ".staticflickr.com/"
                            let url2 = (photo["server"] as! String) + "/" + (photo["id"] as! String)
                            let url3 = "_" + (photo["secret"] as! String) + ".jpg"
                            
                            let url = url1 + url2 + url3
                                print (url)
                                print (photo["title"] as! String)
                            
                        }
                    }
                    completionHandlerForGetPhotos(true, nil)
                } else {
                    completionHandlerForGetPhotos(false, error.debugDescription)
                }
            }
        }
    }

}
