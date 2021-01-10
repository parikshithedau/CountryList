//
//  WebConstants.swift
//  CountryList
//
//  Created by Parikshit on 10/01/21.
//  Copyright © 2021 mindbody. All rights reserved.
//

import Foundation

class WebConstants {
    
    static let appBaseUrl = "https://connect.mindbodyonline.com"
    
    static let getCountry = "/rest/worldregions/country"
    
    static func getProvinces(_ countryId: String) -> String {
        
        return "/rest/worldregions/country/\(countryId)/province"
    }
    
    static func getCountryFlag(_ countryCode: String) -> String {
        
        return "https://www.countryflags.io/\(countryCode)/flat/64.png"
    }
}
