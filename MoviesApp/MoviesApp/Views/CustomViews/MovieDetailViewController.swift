//
//  MovieDetailViewController.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class MovieDetailViewController: UITableViewController {
    
    var presenter: MovieDetailPresenter!
    
    let urlImage = "https://image.tmdb.org/t/p/w342"
    let videoUrl = "https://www.youtube.com/watch?v="
    let thumbnailVideoURL = "https://img.youtube.com/vi/"
    var videosInYouTube = [Video]()
    
    @IBOutlet weak var playerView: YTPlayerView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(HeaderCell().classForCoder, forCellReuseIdentifier: "HeaderCell")

        configureUI()
    }

    
    func loadPresenter (movie: MovieData) {
        let locator = MoviesUseCaseLocator(repository: MoviesRepository(), service: VideosWebService())
        presenter = MovieDetailPresenter(movie: movie, locator: locator)
    }
    
    
    
}
extension MovieDetailViewController{
    
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if videosInYouTube.count == 0{
            return 4
        }
            return 5 + videosInYouTube.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row >= 5{
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailVideoCell") as! VideoCell
            
            let filter = AspectScaledToFillSizeFilter(
                size: cell.thumbnailImage.frame.size
            )
            let url = thumbnailVideoURL + self.videosInYouTube[indexPath.row-5].key + "/0.jpg"
            
            cell.thumbnailImage.af_setImage(
                withURL: URL(string: url)!,
                filter: filter
            )
            cell.videoKey = self.videosInYouTube[indexPath.row-5].key
            
        return cell
        }
        else{
            if indexPath.row == 0{
                var cell : HeaderCell = HeaderCell()

                cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                
                let filter = AspectScaledToFillSizeFilter(
                    size: cell.MoviesImage.frame.size
                )
                let url = urlImage + self.presenter.movie.backdropPath!
                
                cell.MoviesImage.af_setImage(
                    withURL: URL(string: url)!,
                    filter: filter
                )

                
                
                return cell

            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell") as! BasicInfoCell
                cell.MoviesTitle.text = self.presenter.movie.title
                cell.MoviesDate.text = self.presenter.movie.releaseDateString
                cell.MoviesScore.text = "\(self.presenter.movie.voteAverage ?? 0.0)"
                
                let filter = AspectScaledToFillSizeFilter(
                    size: cell.MoviesImage.frame.size
                )
                let url = urlImage + self.presenter.movie.posterPath!
                
                cell.MoviesImage.af_setImage(
                    withURL: URL(string: url)!,
                    filter: filter
                )
                
                
                return cell
                
            }
                
            else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewLittleCell")
                return cell!
                
            }
        

            else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OverViewCell") as! OverviewCell
                cell.MovieOverview.text = self.presenter.movie.overview
                return cell
                
            }
            else if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "VideosLittleCell")
                return cell!
                
            }
            return UITableViewCell()
         
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row >= 5 {
            let cell  = tableView.cellForRow(at: indexPath) as! VideoCell
            if let videoKey = cell.videoKey, !videoKey.isEmpty {
                cell.playerView.load(withVideoId: videoKey)
                cell.thumbnailImage.isHidden = true
                cell.iconPlay.isHidden = true
            }
            
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //TODO: Cell animation (.animate Method available in UITableViewCell)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.row {
        case 0:
            guard self.presenter.movie.backdropPath != nil else { return 0 }
            guard (!(self.presenter.movie.backdropPath?.isEmpty)!) else {return 0}
            return 200
        case 1:
            return 100
        case 2:
            guard self.presenter.movie.overview != nil else { return 0 }
            guard (!(self.presenter.movie.overview?.isEmpty)!) else {return 0}
            return 45
        case 3:
            guard self.presenter.movie.overview != nil else { return 0 }
            guard (!(self.presenter.movie.overview?.isEmpty)!) else {return 0}
            return 70
        case 4:
            return 45
        default:
            return 200
        }
    }
   
}

//MARK: -
private extension MovieDetailViewController {
    
    func configureUI() {
        guard (self.presenter) != nil else {
            return
        }
        
        LoaderView.show(view: self.view)
        presenter.loadVideos{ [unowned self] (videos) in
            
            DispatchQueue.main.async { [unowned self] in
                LoaderView.dismiss()
                if videos?.count == 0 {
                    
                    return
                }
                else{
                    for video in videos! {
                        if video.site == "YouTube"{
                            self.videosInYouTube.append(video as Video)
                        }
                    }
                    self.tableView.reloadData()
                }
                
            }
        }
        
        
    }
}
