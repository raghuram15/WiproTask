//
//  HTTPManager.swift
//  WiproTask
//
//  Created by Raghuram on 04/04/20.
//  Copyright © 2020 Raghuram. All rights reserved.
//

import Foundation

class HTTPManager {
    
   
    
    enum HTTPError : Error {
        case invalidURL
        case invalidResponse(Data?, URLResponse?)
        
    }
    

    public static func get(urlString: String, completionHandler: @escaping(Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            
            completionHandler(.failure(HTTPError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            
            
            guard error == nil else {
                completionHandler(.failure(error!))
                return
            }
            
            
            
            guard let responseData = data,
                let httpResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= httpResponse.statusCode else {
                    
                    completionHandler(.failure(HTTPError.invalidResponse(data, response)))
                    return
            }
            
            completionHandler(.success(responseData))
            
        }
        task.resume()
        
    }
    
    // Download Image
    static func downloadImg(urlString: String, completionHandler: @escaping(Result<Data, Error>) -> Void){
        
        guard let url = URL(string: urlString) else {
            
            completionHandler(.failure(HTTPError.invalidURL))
            return
        }
        
        
        
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            
            if error != nil {
               
                completionHandler(.failure(error!))
                return
            }
            
            
            guard let responseData = data,
                let httpResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= httpResponse.statusCode else {
                    
                    completionHandler(.failure(HTTPError.invalidResponse(data, response)))
                    return
            }
            
            completionHandler(.success(responseData))
            
            
        }).resume()
    }
    
}
