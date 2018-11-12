//
//  FlickrClient.swift
//  Primes Fun
//
//  Created by Dani Springer on 20/06/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import CoreLocation
import CoreData
import UIKit

class FlickrClient: NSObject {
    
    
    // MARK: Properties
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    // MARK: GET
    
    static func getPhotosAbstracted(completion: @escaping (_ data: [URL]?, _ errorReason: UIViewController.alertReason) -> Void) {
        
        let session = URLSession.shared
        let url = flickrURLFromParameters()
        let request = URLRequest(url: url)

        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                completion(nil, .network)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(nil, .unknown)
                return
            }
            
            guard let data = data else {
                completion(nil, .unknown)
                return
            }
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                completion(nil, .unknown)
                return
            }
            
            guard let stat = parsedResult[Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
                completion(nil, .unknown)
                return
            }
            
            
            guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                
                completion(nil, .unknown)
                return
            }
            
            guard let photoArray = photosDictionary[Constants.FlickrResponseKeys.FlickrPhoto] as? [[String:AnyObject]] else {
                completion(nil, .unknown)
                return
            }
            
            var imagesUrls = [URL]()
            
            for _ in 1...70 {
                let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
                let photoDictionary = photoArray[randomPhotoIndex] as [String:AnyObject]
                
                guard let imageUrlString = photoDictionary[Constants.FlickrResponseKeys.MediumURL] as? String else {
                    completion(nil, .unknown)
                    return
                }
                
                guard let imageURL = URL(string: imageUrlString) else {
                    return
                }
                
                imagesUrls.append(imageURL)
                
            }
            completion(imagesUrls, .noError)
        }
        
        task.resume()
    }
    
    // MARK: Helpers
    
    static func downloadSingleImage( imgUrl: URL, completion: @escaping (_ imageData: Data?, _ errorString: String?) -> Void) {
        let session = URLSession.shared
        let request: NSURLRequest = NSURLRequest(url: imgUrl)
        
        let task = session.dataTask(with: request as URLRequest) {data, response, errorString in
            
            if errorString != nil {
                completion(nil, "Could not download image \(imgUrl)")
            } else {
                completion(data, nil)
            }
        }
        task.resume()
    }

    
    
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
