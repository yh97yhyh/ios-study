//
//  CountryTableViewCell.swift
//  WeatherApp
//
//  Created by MZ01-KYONGH on 2022/01/11.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet var countryImage: UIImageView!
    @IBOutlet var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
