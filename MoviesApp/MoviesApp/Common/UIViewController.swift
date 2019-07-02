//
//
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//


import UIKit

extension UIViewController {
    
    
    // Alerts implementation
    
    struct Constants {
        struct Button {
            static let Ok = "OK"
        }
        
        struct Title {
            static let Oops = "OOPS"
            static let Error = "ERROR"
            static let Warning = "WARNING"
        }
    }
    
    enum AlertType {
        case regular
    }
    
    func presentAlert (message: String, type:AlertType) {
        self.presentAlert(title:Constants.Title.Oops, message: message, type: type)
    }
    
    func presentAlert (title: String, message: String, type: AlertType) {
        let alert = UIAlertController(title: Constants.Title.Oops,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: Constants.Button.Ok,
                                      style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentEmptyAlert (message: String) {
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        self.present(alert, animated: true, completion: nil)
    }

}
