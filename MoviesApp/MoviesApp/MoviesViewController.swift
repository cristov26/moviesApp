//
//  ViewController.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var MoviesTableView: UITableView!

    var movieSelected: MovieData!
    var presenter: MoviesPresenter!
    let kSegueToDetailIdentifier = "segueToMovieDetail"
    var moreVideos = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPresenter()
    }
    override func viewWillAppear(_ animated: Bool) {
        configureUI()

    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailController = segue.destination as! MovieDetailViewController
        detailController.loadPresenter(movie: movieSelected)
        
    }

    
    //MARK: - Methods
    
    func loadPresenter () {
        if presenter == nil {
        presenter = MoviesPresenter(locator: MoviesUseCaseLocator.defaultLocator)
        presenter.currentCategory = MovieStoreCategory.Popular
        }
    }
    
    func presentCategory(_ category: MovieStoreCategory){
        if presenter == nil {
            presenter = MoviesPresenter(locator: MoviesUseCaseLocator.defaultLocator)
        }
        presenter.currentCategory = category
    }
    

}
//MARK: -
private extension MoviesViewController {
    
    func configureUI() {
        
        guard (self.presenter) != nil else {
            return
        }
        if  Connectivity.isConnectedToInternet() {
                //Clear Cache Data To Fetch Completly Ordered From Server, Other Side Fetch Only From Cache With Internal Sort
                CacheImpl.clear()
        }
        LoaderView.show(view: self.view)
        presenter.loadMovies { [unowned self] (movies) in
            if movies?.count == 0 {
                return
            }
            DispatchQueue.main.async { [unowned self] in
                LoaderView.dismiss()
                if (self.presenter.categories.count > 0){
                    self.presenter.filterProductsByCurrentCategory()
                    
                    if (self.presenter.movies.count > 0){
                        self.MoviesTableView.reloadData()
                    } else {
                        self.presentAlert(message: self.presenter.emptyDataMessage,
                                          type: AlertType.regular)
                    }
                }
            }
        }
    }
    
}


extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(presenter.movies.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesCell", for: indexPath) as! MoviesCellViewController
        
        cell.setContent(movie: presenter.movies[indexPath.row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        self.movieSelected = self.presenter.movies[indexPath.row]
        self.performSegue(withIdentifier: self.kSegueToDetailIdentifier, sender: self)

        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.presenter.movies.count - 1
        if indexPath.row == lastElement && moreVideos{
            LoaderView.show(view: self.view)
            presenter.loadMovies { [unowned self] (movies) in
                if movies?.count == 0 {
                    return
                }
                DispatchQueue.main.async { [unowned self] in
                    LoaderView.dismiss()
                    if (self.presenter.categories.count > 0){
                        self.presenter.filterProductsByCurrentCategory()
                        
                        if (self.presenter.movies.count > 0){
                            if lastElement+1 != self.presenter.movies.count{
                                self.MoviesTableView.reloadData()
                            }else{
                                self.moreVideos = false
                            }
                        } else {
                            self.presentAlert(message: self.presenter.emptyDataMessage,
                                              type: AlertType.regular)
                        }
                    }
                }
            }
            
        }
        
    }
    
}


