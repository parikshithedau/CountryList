//
//  CountryListTableCell.swift
//  CountryList
//
//  Created by Parikshit on 10/01/21.
//  Copyright © 2021 mindbody. All rights reserved.
//

import UIKit
import SDWebImage

class CountryListTableCell: UITableViewCell {

    @IBOutlet weak var imgViewFlag: UIImageView!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var lblCountryPhoneCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setDetails(_ country: CountryListModel) {
        
        if let name = country.name {
            
            lblCountryName.text = name
        }
        else {
            
            lblCountryName.text = "-"
        }        
        
        if let phoneCode = country.phoneCode {
            
            lblCountryPhoneCode.text = "+" + phoneCode
        }
        else {
            
            lblCountryPhoneCode.text = "-"
        }
        
        if let code = country.code {
            
            lblCountryCode.text = code
            
            loadFlag(code)
        }
        else {
            
            self.imgViewFlag.backgroundColor = Utility.rgb(230, 230, 230, 1)
            
            lblCountryCode.text = "-"
        }
    }
    
    func loadFlag(_ code: String) {
        
        if let url = URL(string:WebConstants.getCountryFlag(code)) {
            
            self.imgViewFlag.backgroundColor = Utility.rgb(230, 230, 230, 1)
            
            imgViewFlag.sd_setImage(with: url, placeholderImage: nil, options: .highPriority) { [weak self] (img, err, type, url) in
                
                guard let self = self else { return }
                
                if img != nil {
                    
                    self.imgViewFlag.backgroundColor = .clear
                }
                else {
                    
                    self.imgViewFlag.backgroundColor = Utility.rgb(230, 230, 230, 1)
                }
            }
        }
        else {

            self.imgViewFlag.backgroundColor = Utility.rgb(230, 230, 230, 1)
        }
    }
}
