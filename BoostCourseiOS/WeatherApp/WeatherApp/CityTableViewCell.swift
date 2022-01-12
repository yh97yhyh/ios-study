//
//  CityTableViewCell.swift
//  WeatherApp
//
//  Created by MZ01-KYONGH on 2022/01/12.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var precipitation: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
