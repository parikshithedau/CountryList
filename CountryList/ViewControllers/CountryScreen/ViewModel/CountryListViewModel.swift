//
//  CountryListViewModel.swift
//  CountryList
//
//  Created by Parikshit on 10/01/21.
//  Copyright © 2021 mindbody. All rights reserved.
//

import UIKit

class CountryListViewModel: NSObject {
    
    private(set) var arrCountries : [CountryListModel]! {
        didSet {
            self.bindCountryListViewModelToController?()
        }
    }
    
    var bindCountryListViewModelToController : (() -> ())? = nil
    
    subscript(index:Int) -> CountryListModel {
        
        return arrCountries[index]
    }
    
    override init() {
        
        super.init()
    }
    
    func fetchCountryList(completion: ((ErrorFail<String>?) -> ())?) {
        
        getCountryList(completion: completion)
    }
}

// MARK: - Web Service
extension CountryListViewModel {
    
    func getCountryList(completion: ((ErrorFail<String>?) -> ())?) {
        
        let api = WebConstants.getCountry
        
        let web = WebService(showInternetProblem: true)
        
        web.shouldPrintLog = true
        
        web.execute(type: .get, name: api, params: nil) { [weak self] (status, msg, res) in
            
            guard let self = self else { return }
            
            if status {
                
                guard let arr = res as? [[String: Any]] else {
                    
                    completion?(.fail(StringConstants.errSomethingWentWrong))
                    
                    return
                }
                
                guard let arrCountries = CountryListModel.object(arr) else {
                    
                    completion?(.fail(StringConstants.errSomethingWentWrong))

                    return
                }
                
                self.arrCountries = arrCountries
            }
            else {
                
                completion?(.fail(msg!))
            }
        }
    }
}
