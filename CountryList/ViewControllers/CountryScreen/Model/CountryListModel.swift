//
//  CountryListModel.swift
//  CountryList
//
//  Created by Parikshit on 10/01/21.
//  Copyright © 2021 mindbody. All rights reserved.
//

import ObjectMapper

struct CountryListModel: Mappable {
    
    var id: Int?
    var name: String?
    var code: String?
    var phoneCode: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        
        id <- map["ID"]
        name <- map["Name"]
        code <- map["Code"]
        phoneCode <- map["PhoneCode"]
    }
    
    static func object(_ object: [[String:Any]]) -> [CountryListModel]? {
        
        return Mapper<CountryListModel>().mapArray(JSONArray: object)
    }
}
