//
//  ViewControllerModel.swift
//  VinayCodingTest
//
//  Created by  Vinay on 23/08/18.
//  Copyright © 2018 Vinay. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    //MARK: - Static(Class) Methods
    
    static func createAlertWithoutAction(message: String, title: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        alert.addAction(okAction)
        return alert
    }
    

    
}
