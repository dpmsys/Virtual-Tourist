//
//  Flickr.swift
//  Virtual Tourist
//
//  Created by David Mulvihill on 2/9/19.
//  Copyright © 2019 David Mulvihill. All rights reserved.
//

import Foundation

class FlickrClient : NSObject {
    
    var session = URLSession.shared

    enum FlickrError: Error {
        case invalidJSONData
    }
    
    override init() {
        super.init()
    }
    
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: flickrURLFromParameters(parameters, method: method))

        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard (error == nil) else {
                print ("error")
                completionHandlerForGET("Failed GET method" as AnyObject, NSError(domain: error?.localizedDescription ?? "Unknown error in get", code: 1 , userInfo: nil))
                return
            }
            
            print ((response as? HTTPURLResponse)?.statusCode ?? "Empty status code")
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print ((response as? HTTPURLResponse)?.statusCode ?? "Empty status code")
                completionHandlerForGET("Failed GET method" as AnyObject, NSError(domain: "Server returned status other than 2xx! - \((response as? HTTPURLResponse)?.statusCode ?? 10000)", code: 1 , userInfo: nil))
                return
            }
            
            guard let data = data else {
                print ("no data")
                completionHandlerForGET("Failed GET method" as AnyObject, NSError(domain: "No data returned by GET", code: 1 , userInfo: nil))
                return
            }
            print("calling convert")
            let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
            print(string1)
            print(data)
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
    }
    
    private func flickrURLFromParameters(_ parameters: [String:AnyObject], method: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = FlickrClient.Constants.APIScheme
        components.host = FlickrClient.Constants.APIHost
        components.path = FlickrClient.Constants.APIPath
        components.queryItems = [URLQueryItem]()
        
        let queryItem = URLQueryItem(name: FlickrClient.ParameterKeys.Method, value: "\(method ?? "")")
        components.queryItems!.append(queryItem)
        for (key,value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        print ("URL")
        print (components.url!)
        
        return components.url!
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        
        let range = 14..<data.count-1
        let newData = data.subdata(in: range)
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
 //           print(parsedResult)
        }catch{
            
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    
    class func sharedInstance() -> FlickrClient {
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        return Singleton.sharedInstance
    }
}
