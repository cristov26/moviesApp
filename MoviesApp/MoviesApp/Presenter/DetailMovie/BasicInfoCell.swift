//
//  MainCell.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import UIKit

class BasicInfoCell: UITableViewCell {
    @IBOutlet weak var MoviesImage: UIImageView!
    @IBOutlet weak var MoviesTitle: UILabel!
    @IBOutlet weak var MoviesDate: UILabel!
    @IBOutlet weak var MoviesScore: UILabel!
    
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
