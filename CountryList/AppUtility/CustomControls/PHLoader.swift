//
//  PHLoader.swift
//  CountryList
//
//  Created by Parikshit on 10/01/21.
//  Copyright © 2021 mindbody. All rights reserved.
//

import UIKit

class PHLoader: UIView {

    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Methods
    private func setupLoader() {
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        activityIndicator = UIActivityIndicatorView(style: .white)
                    
        activityIndicator.center = CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    private func showViewWithAnimation() {
        
        UIView.animate(withDuration: 0.3) {
            
            self.alpha = 1.0
        }
    }
    
    private func hideViewWithAnimation() {
       
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0.0
            }) { (finished) in
                
                self.hideView()
            }
        }
    }
    
    private func hideView() {
        
        self.activityIndicator?.stopAnimating()
        
        self.removeFromSuperview()
       
        self.activityIndicator = nil
    }
    
    // MARK: - Utility Methods
    func showIn(view: UIView?)
    {
        hideView()
        
        var containerView: UIView! = nil
        
        if let inView = view
        {
            containerView = inView
        }
        else {
            
            let appDel = UIApplication.shared.delegate as? AppDelegate

            containerView = appDel?.window?.rootViewController?.view
        }
        
        self.frame = containerView!.bounds
        
        setupLoader()
        
        containerView?.addSubview(self)
        
        self.alpha = 0.0
        
        showViewWithAnimation()
    }
    
    func hide() {
        
        hideViewWithAnimation()
    }
}
