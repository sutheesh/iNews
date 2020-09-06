//
//  NewsHelper.swift
//  TuneMe
//
//  Created by Sutheesh Sukumaran on 9/5/20.
//  Copyright © 2020 ilabbs.com. All rights reserved.
//

import Foundation
import UIKit

class NewsHelper {
    
    class func showAlert(vc:UIViewController,title:String = "",message:String = "", actions:[UIAlertAction]? = nil ){
        
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }else {
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
        }
        vc.present(alert, animated: true, completion: nil)
        
    }
}
