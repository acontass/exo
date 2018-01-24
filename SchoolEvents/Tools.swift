//
//  Tools.swift
//  SchoolEvents
//
//  Created by acontass on 23/01/2018.
//  Copyright © 2018 acontass. All rights reserved.
//

import UIKit

struct Tools {
    
    /**
     Create an alert of UIAlertController type with title, message and buttons.
     
     - returns: The configured UIAlertController.
     
     - parameter title: The title string or nil.
     - parameter message: The message string.
     - parameter buttons: The buttons variable arguments strings (you can add as many strings as you wish).
     - parameter completion: The an handler for set the buttons actions, the button title is passed in parameter. This parameter can also set to nil all buttons have no action.
     
     - remark:
     - The Cancel style is set if the button title is "Cancel" or is translation.
     */
    
    static public func createAlert(title : String?, message: String, buttons : CVarArg..., completion: ((String) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for elem in buttons {
            if let button = elem as? String {
                alert.addAction(UIAlertAction(title: button, style: (button != "Cancel") ? UIAlertActionStyle.default : UIAlertActionStyle.cancel, handler: { (action) in
                    completion?(button)
                }))
            }
        }
        return alert
    }
}
