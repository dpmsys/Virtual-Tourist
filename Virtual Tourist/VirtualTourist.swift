//
//  VirtualTourist.swift
//  Virtual Tourist
//
//  Created by David Mulvihill on 2/8/19.
//  Copyright © 2019 David Mulvihill. All rights reserved.
//

import Foundation
import MapKit

var annotations = [MKPointAnnotation] ()
var locations = [Location] ()

struct PhotoInfo {
    var id: String = ""
    var secret: String = ""
    var farm: String = ""
    var server: String = ""
    var title: String = ""
    var url: String = ""
    var image: UIImage?
    
    init (userDict: Dictionary<String, Any>) {
        self.id = userDict[FlickrClient.JSONResponseKeys.Id] as! String
        self.secret = userDict[FlickrClient.JSONResponseKeys.Secret] as! String
        self.farm = String(userDict[FlickrClient.JSONResponseKeys.Farm] as! Int)
        self.server = userDict[FlickrClient.JSONResponseKeys.Server] as! String
        self.title = userDict[FlickrClient.JSONResponseKeys.Title] as! String
        
        let url1 = "https://farm" + String(userDict["farm"] as! Int) + ".staticflickr.com/"
        let url2 = (userDict["server"] as! String) + "/" + (userDict["id"] as! String)
        let url3 = "_" + (userDict["secret"] as! String) + ".jpg"
        
        self.url = url1 + url2 + url3
        
        
    }
}

var photoAlbum: [PhotoInfo] = []
