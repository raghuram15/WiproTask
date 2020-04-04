//
//  DataModel.swift
//  WiproTask
//
//  Created by Raghuram on 04/04/20.
//  Copyright © 2020 Raghuram. All rights reserved.
//

import Foundation

struct DataModel : Decodable{
    
    var title: String?
    var rows : [Animals]
}

struct Animals: Decodable {
    
    var title: String?
    var description : String?
    var imageHref: String?
}
