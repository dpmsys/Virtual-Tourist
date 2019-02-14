//
//  FlickrConvenience.swift
//  Virtual Tourist
//
//  Created by David Mulvihill on 2/9/19.
//  Copyright © 2019 David Mulvihill. All rights reserved.
//

import Foundation
import MapKit
import CoreData

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
                if let flickrPhotos = results?[FlickrClient.JSONResponseKeys.Photos] as! Dictionary<String, Any>? {
                    if let photoArray = flickrPhotos["photo"] as! [Dictionary<String, Any>]? {
                        for photo in photoArray {
                            let url1 = "https://farm" + String(photo["farm"] as! Int) + ".staticflickr.com/"
                            let url2 = (photo["server"] as! String) + "/" + (photo["id"] as! String)
                            let url3 = "_" + (photo["secret"] as! String) + ".jpg"
                            
                            let url = url1 + url2 + url3
                            print (url)
                            print (photo["title"] as! String)
                            
                            var photoData = PhotoInfo(userDict: photo)
                            
                            self.downloadImage(url: photoData.url) { (image, error) in
                                if (error != nil) {
                                    print ("error from download image")
                                }else{
                                    photoData.image = image
                                }
                            }
                            
                            photoAlbum.append(photoData)
                            

                        }
                    }
                    completionHandlerForGetPhotos(true, nil)
                } else {
                    completionHandlerForGetPhotos(false, error.debugDescription)
                }
            }
        }
    }

    func downloadImage(url: String, _ completionHandlerForGetPhotos: @escaping (_ image: UIImage, _ error: NSError?) -> Void) {
        
        let url1 = URL(string: url)
        let imageRequest = URLRequest(url: url1!)
            
        print(imageRequest.url)
        
        let task = session.dataTask(with: imageRequest as URLRequest) { (data, response, error) in
            guard (error == nil) else {
                print ("error")
                 return
            }
            
            print ((response as? HTTPURLResponse)?.statusCode)
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print ((response as? HTTPURLResponse)?.statusCode)
                return
            }
            
            guard let data = data else {
                print ("no data")
                return
            }
            print("calling convert")
            let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
            print(string1)
            print(data)
            completionHandlerForGetPhotos(UIImage(data: data)!,nil)
         }
        
        task.resume()
        
    }
}
