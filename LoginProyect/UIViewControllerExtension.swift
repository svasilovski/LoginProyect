//
//  MessageFiles.swift
//  LoginProyect
//
//  Created by SAMUEL on 2/4/18.
//  Copyright © 2018 SAMUEL VASILOVSKI. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func displayMyAlertMessage(_ userMessage:String, addButton:Bool = true) -> UIAlertController{
        let myAlert = UIAlertController(
            title: "Alert",
            message: userMessage,
            preferredStyle: UIAlertControllerStyle.alert
        );
        
        if(addButton){
            let okAction = UIAlertAction(
                title: "Ok",
                style: UIAlertActionStyle.default,
                handler: nil
            );
            
            myAlert.addAction(okAction);
        }
        
        return myAlert;
        
        // self.present(myAlert, animated: true, completion: nil);
    }
}
