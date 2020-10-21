//
//  MoviesCellViewController.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MoviesCellViewController: UITableViewCell {
   
    @IBOutlet weak var MoviesImage: UIImageView!
    @IBOutlet weak var MoviesTitle: UILabel!
    @IBOutlet weak var MoviesDescription: UILabel!
    @IBOutlet weak var MoviesYear: UILabel!
    let urlImage = "https://image.tmdb.org/t/p/w342"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
    func setContent(movie: MovieData) {
        
        //TODO: Get this info when it comes from server
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: self.MoviesImage.frame.size,
            radius: 5.0
        )
        let url = urlImage + movie.posterPath!
        
        self.MoviesImage.af.setImage(
            withURL: URL(string: url)!,
            placeholderImage: UIImage(named: "icon - Movie"),
            filter: filter
        )
        
        MoviesTitle.text = "\(movie.title)"
        MoviesDescription.text = movie.overview
        MoviesYear.text = movie.releaseDateString
    }
}
