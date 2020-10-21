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
    var videosInYouTube = [Video]()
    
    var didChangeTitle = false
    var defaultTitle = ""
    let animateUp: CATransition = {
        let animation = CATransition()
        animation.duration = 0.5
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        return animation
    }()
    let animateDown: CATransition = {
        let animation = CATransition()
        animation.duration = 0.5
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromBottom
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        return animation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        if indexPath.row == 0{
            var cell : HeaderCell = HeaderCell()
            
            cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            
            let filter = AspectScaledToFillSizeFilter(
                size: cell.MoviesImage.frame.size
            )
            let url = urlImage + self.presenter.movie.backdropPath!
            
            cell.MoviesImage.af.setImage(
                withURL: URL(string: url)!,
                filter: filter
            )
            
            
            
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell") as! BasicInfoCell
            cell.MoviesTitle.text = self.presenter.movie.title
            cell.MoviesDate.text = self.presenter.movie.releaseDateString
            cell.MoviesScore.text = "\(self.presenter.movie.voteAverage ?? 0.0)"
            
            let filter = AspectScaledToFillSizeFilter(
                size: cell.MoviesImage.frame.size
            )
            let url = urlImage + self.presenter.movie.posterPath!
            
            cell.MoviesImage.af.setImage(
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
            
        } else if indexPath.row >= 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailVideoCell") as! VideoCell
            cell.videoKey = self.videosInYouTube[indexPath.row-5].key
            return cell
        }
        return UITableViewCell()
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell  = cell as? VideoCell else { return }
        if let videoKey = cell.videoKey, !videoKey.isEmpty {
            cell.loadVideo(VideoId: videoKey)
        }
    }
}

//MARK: -ScrollView
extension MovieDetailViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellIndexPath = IndexPath(row: 1, section: 0)
        guard let cell  = tableView.cellForRow(at: cellIndexPath) as? BasicInfoCell, let labelName = cell.MoviesTitle else { return }
        if scrollView.contentOffset.y + 88 >= (self.tableView.rectForRow(at: cellIndexPath).origin.y + labelName.frame.origin.y + labelName.frame.height) && !didChangeTitle {
            if let label = navigationItem.titleView as? UILabel {
                label.layer.add(animateUp, forKey: "changeTitle")
                label.text = labelName.text
            }
            didChangeTitle = true
        } else if scrollView.contentOffset.y + 88 < (self.tableView.rectForRow(at: cellIndexPath).origin.y + labelName.frame.origin.y) && didChangeTitle {
            if let label = navigationItem.titleView as? UILabel {
                label.layer.add(animateDown, forKey: "changeTitle")
                label.text = defaultTitle
            }
            didChangeTitle = false
        }
    }
}

//MARK: -Helpers
private extension MovieDetailViewController {
    
    func configureUI() {
        guard (self.presenter) != nil else {
            return
        }
        
        LoaderView.show(view: self.view)
        createNavBarTitle()
        presenter.loadVideos{ [weak self] (videos) in
            
            
            DispatchQueue.main.async {
                LoaderView.dismiss()
                if videos?.count == 0 {
                    
                    return
                }
                else{
                    for video in videos! {
                        if video.site == "YouTube" {
                            self?.videosInYouTube.append(video as Video)
                        }
                    }
                    self?.tableView.reloadData()
                }
                
            }
        }
    }
    
    func createNavBarTitle() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let titleLabelView = UILabel.init(frame: CGRect(x: 10, y: 0, width: 200, height: 44))
        titleLabelView.backgroundColor = .clear
        titleLabelView.textAlignment = .center
        titleLabelView.textColor = UIColor.white
        titleLabelView.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabelView.text = defaultTitle
        self.navigationItem.titleView = titleLabelView
    }
}
