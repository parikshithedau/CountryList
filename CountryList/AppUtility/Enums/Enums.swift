//
//  Enums.swift
//  CountryList
//
//  Created by Parikshit on 10/01/21.
//  Copyright © 2021 mindbody. All rights reserved.
//

import Foundation
import UIKit

enum Storyboard: String {
    
    case main = "Main"
    
    func instantiateViewController<T: UIViewController>(viewController: T.Type) -> T {
        let storyboard = UIStoryboard(name: self.rawValue, bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as? T {
            return viewController
        } else {
            fatalError("View Controller not found.")
        }
    }
}

enum ErrorFail<String> {
    
   case fail(String)
}
