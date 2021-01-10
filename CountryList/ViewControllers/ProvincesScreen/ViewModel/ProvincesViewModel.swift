//
//  ProvincesViewModel.swift
//  CountryList
//
//  Created by Parikshit on 10/01/21.
//  Copyright © 2021 mindbody. All rights reserved.
//

import UIKit

class ProvincesViewModel: NSObject {

    private(set) var arrProvinces : [ProvincesModel]! {
        didSet {
            self.bindProvincesViewModelToController?()
        }
    }
    
    var bindProvincesViewModelToController : (() -> ())? = nil
    
    var countryID: Int!
    
    subscript(index:Int) -> ProvincesModel {
        
        return arrProvinces[index]
    }
    
    override init() {
        
        super.init()
    }
    
    func fetchProvincesList(completion: ((ErrorFail<String>?) -> ())?) {
        
        getProvincesList(completion: completion)
    }
}

// MARK: - Web Service
extension ProvincesViewModel {
    
    func getProvincesList(completion: ((ErrorFail<String>?) -> ())?) {
        
        let api = WebConstants.getProvinces(String(countryID!))
        
        let web = WebService(showInternetProblem: true)
        
        web.shouldPrintLog = true
        
        web.execute(type: .get, name: api, params: nil) { [weak self] (status, msg, res) in
            
            guard let self = self else { return }
            
            if status {
                
                guard let arr = res as? [[String: Any]] else {
                    
                    completion?(.fail(StringConstants.errSomethingWentWrong))
                    
                    return
                }
                
                guard let arrProvinces = ProvincesModel.object(arr) else {
                    
                    completion?(.fail(StringConstants.errSomethingWentWrong))

                    return
                }
                
                self.arrProvinces = arrProvinces
            }
            else {
                
                completion?(.fail(msg!))
            }
        }
    }
}
