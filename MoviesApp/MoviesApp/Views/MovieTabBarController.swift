//
//  MovieTabBarController.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import UIKit


class MovieTabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tabBar.barStyle = .black
        tabBar.unselectedItemTintColor = UIColor.white
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let popularViewController = storyboard.instantiateViewController(withIdentifier: "navController") as! UINavigationController
        let topRatedViewController = storyboard.instantiateViewController(withIdentifier: "navController") as! UINavigationController
        let upcomingViewController = storyboard.instantiateViewController(withIdentifier: "navController") as! UINavigationController
        
        let popular = "Popular"
        let topRated = "Top rated"
        let upcoming = "Upcoming"
        
        let popularItem = UITabBarItem(title: popular, image: UIImage(named: "icon-Popular"), tag: 0)
        let topRatedItem = UITabBarItem(title: topRated , image: UIImage(named: "icon-TopRated"), tag: 0)
        let upcomingItem = UITabBarItem(title: upcoming, image: UIImage(named: "icon-Upcoming"), tag: 0)

        
        popularViewController.tabBarItem = popularItem
        popularViewController.navigationBar.topItem?.title = popular
        
        topRatedViewController.tabBarItem = topRatedItem
        topRatedViewController.navigationBar.topItem?.title = topRated

        upcomingViewController.tabBarItem = upcomingItem
        upcomingViewController.navigationBar.topItem?.title = upcoming

        
      
        (topRatedViewController.viewControllers[0] as! MoviesViewController).presentCategory(MovieStoreCategory.TopRated)
        (upcomingViewController.viewControllers[0] as! MoviesViewController).presentCategory(MovieStoreCategory.Upcoming)
        viewControllers = [popularViewController, topRatedViewController, upcomingViewController]
    }
}
