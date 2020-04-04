//
//  DataViewModel.swift
//  WiproTask
//
//  Created by Raghuram on 04/04/20.
//  Copyright © 2020 Raghuram. All rights reserved.
//

import Foundation

class DataViewModel {
    
    
    func fetchBreaches(completion: @escaping (Result<DataModel, Error>) -> Void) {
        
        
        
        HTTPManager.shared.get(urlString: Constants.url, completionHandler: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                print ("failure", error)
            case .success(let dta) :
                print(dta)
                
                do
                {
                    let dataAsString = String(data: dta, encoding: .windowsCP1250)
                    let dta1 = dataAsString?.data(using: .utf8)
                    let data = try JSONDecoder().decode(DataModel.self, from: dta1!)
                    completion(.success(data))
                } catch {
                    // deal with error from JSON decoding if used in production
                    print(error.localizedDescription)
                }
            }
        })
    }
}
