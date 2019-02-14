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
    
    init (){
        
    }
}

var photoAlbum: [PhotoInfo] = []
