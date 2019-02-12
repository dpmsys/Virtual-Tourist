//
//  FlickrConstants.swift
//  Virtual Tourist
//
//  Created by David Mulvihill on 2/9/19.
//  Copyright © 2019 David Mulvihill. All rights reserved.
//

import Foundation

extension FlickrClient {
    
    struct Constants {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest/"
        static let APIKey = "f7b7c70f20cd43db75ad57c27bf950f9"
        static let APISecret = "cb9f81a55fae5766"
        static let Format = "json"
        static let SearchRadius = 10  // kilometers
    }
    
    struct Methods {
        static let Search = "flickr.photos.search"
    }
    
    struct ParameterKeys {

        static let APIKey = "api_key"
        static let Method = "method"
        static let Format = "format"
        static let Latitude = "lat"
        static let Longitude = "lon"
        static let Radius = "radius"
        static let PerPage = "per_page"
        static let InGetty = "in_getty"
        
    }

    struct JSONResponseKeys {
        static let Photos = "photos"
    }
}
