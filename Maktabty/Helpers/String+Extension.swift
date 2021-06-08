//
//  String+Extension.swift
//  Maktabty
//
//  Created by Macbook on 20/05/2021.
//

import Foundation


extension String{
    
//    func isValidEmail() -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
//
//        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailPredicate.evaluate(with: self)
//    }
//
//
//
//    func isValidPassword(mini: Int = 8, max: Int = 8) -> Bool{
//
//        //Minimum 8 characters at least 1 Alphabet and 1 Number:
//        var passRegEx = ""
//        if mini >= max{
//            passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{\(mini),}$"
//        }else{
//            passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{\(mini),\(max)}$"
//        }
//
//        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passRegEx)
//        return passwordPredicate.evaluate(with: self)
//    }
    var localized : String {
        return NSLocalizedString(self, comment: "")
    }
}
