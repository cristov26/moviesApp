 //
//  AppDelegate.swift
//  MoviesApp
//
 //  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        //Clear Database and Create a new one when the app got an update, to update the new fields on this one
    
        let defaults = UserDefaults.standard
        let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        
        if let lastBuildVersion = defaults.string(forKey: "buildVersion"){
            
            let currentBuildNewerThanOld = compareVersions(lastBuildVersion, with: build)
            
            if currentBuildNewerThanOld {
                CacheImpl.clear()
                defaults.set(build, forKey: "buildVersion")
            }
        }
        else{
            defaults.set(build, forKey: "buildVersion")
        }
        
        return true
    }
    
    private func compareVersions (_ savedVersion: String, with buildVersion: String) -> Bool{
        let currentBuildNewerThanSaved = buildVersion.compare(savedVersion, options: NSString.CompareOptions.numeric, range: nil, locale: nil) == ComparisonResult.orderedDescending
        return currentBuildNewerThanSaved
    }
}

