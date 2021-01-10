//
//  ProvincesTableCell.swift
//  CountryList
//
//  Created by Parikshit on 10/01/21.
//  Copyright © 2021 mindbody. All rights reserved.
//

import UIKit

class ProvincesTableCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setDetails(_ province: ProvincesModel) {
        
        if let name = province.name {
            
            lblName.text = name
        }
        else {
            
            lblName.text = "-"
        }
        
        if let code = province.code {
            
            lblCode.text = code
        }
        else {
                        
            lblCode.text = "-"
        }
    }
}
