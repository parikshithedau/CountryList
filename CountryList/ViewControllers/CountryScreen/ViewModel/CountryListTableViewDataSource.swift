//
//  CountryListTableViewDataSource.swift
//  CountryList
//
//  Created by Parikshit on 10/01/21.
//  Copyright © 2021 mindbody. All rights reserved.
//

import UIKit
import Foundation

class CountryListTableViewDataSource <CELL : UITableViewCell,T>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var cellIdentifier : String!
    private var items : [T]!
    var configureCell : (CELL, T) -> () = {_,_ in }
    
    var didSelect: ((T, IndexPath) -> ())? = nil
    
    init(cellIdentifier : String, items : [T], configureCell : @escaping (CELL, T) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items =  items
        self.configureCell = configureCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if items.count == 0 {
            
            tableView.separatorStyle = .none
        }
        else {
            
            tableView.separatorStyle = .singleLine
        }
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CELL
        
        let item = self.items[indexPath.row]
        self.configureCell(cell, item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.items[indexPath.row]
        
        didSelect?(item, indexPath)
    }
    
    // Deinit
    deinit {
        
        print("------------ DataSource Deinited ----------------")
    }
}
