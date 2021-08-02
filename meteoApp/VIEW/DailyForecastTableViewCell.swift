//
//  DailyForecastTableViewCell.swift
//  meteoApp
//
//  Created by Adrien Cullier on 27/07/2021.
//

import UIKit

class DailyForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var popLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.backgroundColor = .clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
