//
//  Utility.swift
//  CountryList
//
//  Created by Parikshit on 10/01/21.
//  Copyright © 2021 mindbody. All rights reserved.
//

import UIKit
import Toaster

class Utility: NSObject {
    
    static func rgb(_ red:CGFloat, _ green:CGFloat, _ blue:CGFloat, _ alpha:CGFloat) -> UIColor {
        
        let color = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
        return color
    }
    
    static func alert(title: String =
        StringConstants.appName, message: String?, delegate: UIViewController?, buttons: [String]? = [StringConstants.ok], cancel: String?, completion: ((String)->())?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        if buttons != nil {
            
            for i in 0..<buttons!.count {
                
                let action = UIAlertAction(title: buttons![i], style: UIAlertAction.Style.default) { (action) in
                    
                    completion?(action.title!)
                }
                
                alert.addAction(action)
            }
        }
        
        if cancel != nil {
            
            let cancelAction = UIAlertAction(title: cancel, style: UIAlertAction.Style.cancel) { (action) in
                
                completion?(action.title!)
            }
            
            alert.addAction(cancelAction)
        }
        
        delegate?.present(alert, animated: true, completion: nil)
    }
    
    static func showToast(msg: String, delay:TimeInterval = 0, duration:TimeInterval = 2, bottom:CGFloat = 80) {
        
        ToastCenter.default.cancelAll()
        
        let toast = Toast(text: msg, delay: delay, duration: duration)
        
        toast.view.bottomOffsetPortrait = bottom
        
        toast.view.backgroundColor = Utility.rgb(30, 30, 30, 1)
        
        toast.show()
    }
}
