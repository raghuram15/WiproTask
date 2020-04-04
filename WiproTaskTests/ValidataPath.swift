//
//  ValidataPath.swift
//  WiproTaskTests
//
//  Created by Raghuram on 04/04/20.
//  Copyright © 2020 Raghuram. All rights reserved.
//

import XCTest

@testable import WiproTask
class ValidataPath: XCTestCase {

    
     var sut: URLSession!
    
    override func setUp() {
         super.setUp()
        sut = URLSession(configuration: .default)
    
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    
    func testValidJSONPlaceholer() {
        
        let url = URL(string: Constants.url)
        
        let promise = expectation(description: "Status code: 200 or 201")

        
        let dataTask = sut.dataTask(with: url!) { data, response, error in

            
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {

                if statusCode == 200 || statusCode == 201 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()

       
        wait(for: [promise], timeout: 5)
    }

    
    

}
