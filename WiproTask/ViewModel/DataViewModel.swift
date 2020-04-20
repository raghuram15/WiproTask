//
//  DataViewModel.swift
//  WiproTask
//
//  Created by Raghuram on 04/04/20.
//  Copyright © 2020 Raghuram. All rights reserved.
//

import Foundation
import UIKit


class DataViewModel {
    
     var dataMdl = DataModel(title: "", rows: [])
     var imageCache = NSCache<AnyObject, AnyObject>()
}

extension DataViewModel {
    
    
    func fetchBreaches(completion: @escaping (Result<DataModel, Error>) -> Void) {
        
        
        
        HTTPManager.get(urlString: Constants.url, completionHandler: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                
                completion(.failure(error))
            case .success(let dta) :
              
                
                do
                {
                    let dataAsString = String(data: dta, encoding: .windowsCP1250)
                    let dta1 = dataAsString?.data(using: .utf8)
                    let data = try JSONDecoder().decode(DataModel.self, from: dta1!)
                    self.dataMdl = data
                    completion(.success(data))
                } catch {
                    // deal with error from JSON decoding if used in production
                   // print(error.localizedDescription)
                }
            }
        })
    }
    
    func getImageData(imageUrl : String ,completion: @escaping(Result<Data, Error>) -> Void) {
        
        HTTPManager.downloadImg(urlString: imageUrl, completionHandler: {[weak self] result in
            guard let self = self else {return}
            
            switch result {
                
            case .failure(let error):
               
                completion(.failure(error))
            case .success(let data) :
                
                if let imageToCache = UIImage(data: data){
                    self.imageCache.setObject(imageToCache, forKey: imageUrl as AnyObject)
                }
                completion(.success(data))
                
            }
            
        })
        
        
    }
    
}
