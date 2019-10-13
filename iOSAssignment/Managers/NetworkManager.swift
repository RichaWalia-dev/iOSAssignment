//
//  NetworkManager.swift
//  iOSAssignment
//
//  Created by Richa Walia on 10/10/19.
//  Copyright © 2019 Richa Walia. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let imageCache:NSCache<NSString, UIImage>
    var session: URLSession!
    
    private init() {
        self.session = URLSession.shared
        self.imageCache = NSCache()
    }
    
    func getFeeds(completion: @escaping (_ feedData: Feed?, _ error: Error? ) -> Void) {
        guard let url = URL(string: Constants.url) else {
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let feed: Feed = try decoder.decode(Feed.self, from: data)
                    completion(feed, nil)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                    completion(nil,nil)
                }
                
            } else {
                completion(nil, nil)
            }
        }
        task.resume()
    }
    
    func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, nil)
        } else {
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    completion(nil, error)
                } else if let data = data, let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image, nil)
                } else {
                    completion(nil, nil)
                }
            })
            task.resume()
        }
    }
    
}
