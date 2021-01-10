//
//  ProvincesModel.swift
//  CountryList
//
//  Created by Parikshit on 10/01/21.
//  Copyright © 2021 mindbody. All rights reserved.
//

import UIKit
import ObjectMapper

struct ProvincesModel: Mappable {

    var id: String?
    var code: String?
    var name: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        
        id <- map["ID"]
        name <- map["Name"]
        code <- map["Code"]
    }
    
    static func object(_ object: [[String:Any]]) -> [ProvincesModel]? {
        
        return Mapper<ProvincesModel>().mapArray(JSONArray: object)
    }
}
