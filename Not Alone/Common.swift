//
//  Common.swift
//  Not Alone
//
//  Created by Nooralam Shaikh on 07/10/18.
//  Copyright © 2018 Nooralam Shaikh. All rights reserved.
//

import UIKit
import SVProgressHUD

private let sharedInstance = Common()

class Common: NSObject {
        
    class var sharedInst: Common {
        return sharedInstance
    }
    
    func parseData(with data: Data?) -> [String:Any]? {
        guard let dataObject = data else { return nil}
        do {
            let userData = try JSONSerialization.jsonObject(with: dataObject, options: []) as? [String : Any]
            return userData
        } catch let error {
            print(error)
            return nil
        }
    }
    
}

extension Common{
    //MARK:- Validations Email and Mobile
    
    func validateEmailString(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func validateMobileNo(validateNumber: String) -> Bool {
        let numberRegEx = "[0-9]{10}"
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        return numberTest.evaluate(with: validateNumber)
    }
    
    
}

extension Common {
    func showLoader() {
        SVProgressHUD.show()
    }
    func hideLoader() {
        SVProgressHUD.dismiss()
    }
}
