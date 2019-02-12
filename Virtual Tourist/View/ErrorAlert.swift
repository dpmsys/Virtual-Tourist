//
//  ErrorAlert.swift
//  Virtual Tourist
//
//  Created by David Mulvihill on 2/8/19.
//  Copyright © 2019 David Mulvihill. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //
    // output error messages via UIAlertController
    //
    
    func errorAlert(message: String) {
        
        performUIUpdatesOnMain () {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
}
