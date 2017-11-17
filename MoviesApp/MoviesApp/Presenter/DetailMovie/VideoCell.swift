//
//  VideoCell.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {
    @IBOutlet weak var iconPlay: UIImageView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet var playerView: YTPlayerView!
    var isLoaded = false
    var videoKey: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage.image = nil
        thumbnailImage.isHidden = false
        iconPlay.isHidden = false
    }

}
