//
//  FlickrClient.swift
//  Prime Numbers Fun
//
//  Created by Dani Springer on 20/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//


import Foundation
import CoreLocation
import CoreData
import UIKit


class FlickrClient: NSObject {
    
    
    // MARK: Properties
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    // MARK: GET
    
    static func getPhotosAbstracted(completion: @escaping (_ data: [UIImage]?, _ errorReason: String?) -> Void) {
        
        let session = URLSession.shared
        let url = flickrURLFromParameters()
        let request = URLRequest(url: url)

        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print("network error")
                completion(nil, "network")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Status code not 2xx")
                completion(nil, "unknown")
                return
            }
            
            guard let data = data else {
                print("No data")
                completion(nil, "unknown")
                return
            }
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Could not parse data: '\(data)'")
                completion(nil, "unknown")
                return
            }
            
            guard let stat = parsedResult[Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
                print("Flickr API returned an error. See error code and message in \(parsedResult)")
                completion(nil, "unknown")
                return
            }
            
            
            guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                print("Cannot find keys '\(Constants.FlickrResponseKeys.Photos)' in \(parsedResult)")
                completion(nil, "unknown")
                return
            }
            
            guard let photoArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                print("Cannot find key '\(Constants.FlickrResponseKeys.Photo)' in \(parsedResult)")
                completion(nil, "unknown")
                return
            }
            
            var images = [UIImage]()
            
            for _ in 1...20 {
                let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
                let photoDictionary = photoArray[randomPhotoIndex] as [String:AnyObject]
                
                guard let imageUrlString = photoDictionary[Constants.FlickrResponseKeys.MediumURL] as? String else {
                    print("Cannot find key '\(Constants.FlickrResponseKeys.MediumURL)' in \(photoDictionary)")
                    completion(nil, "unknown")
                    return
                }
                
                let imageURL = URL(string: imageUrlString)
                
                if let imageData = try? Data(contentsOf: imageURL!) {
                    
                    if let actualImage = UIImage(data: imageData) {
                        
                        images.append(actualImage)
                    }
                    
                } else {
                    print("Image does not exist at \(imageURL!)")
                }
            }
            
            
            completion(images, nil)
            
        }
        
        task.resume()
    }
    
    // MARK: Helpers
    
    static func flickrURLFromParameters() -> URL {
        
        let parameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback, Constants.FlickrParameterKeys.PerPage: Constants.FlickrParameterValues.PerPage, Constants.FlickrParameterKeys.GroupID: Constants.FlickrParameterValues.GroupID
        ]
        
        var components = URLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }

}
