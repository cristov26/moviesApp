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
        tabBar.unselectedItemTintColor = .white
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
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        //Then, add the custom top line view with custom color. And set the default background color of tabbar
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.2))
        lineView.backgroundColor = UIColor(red: 128/255   , green: 127/255, blue: 137/255, alpha: 1)
        tabBar.addSubview(lineView)
    }
}
