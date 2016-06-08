//
//  DataValidator.swift
//  Saitama
//
//  Created by Mohamed Adly on 6/4/16.
//  Copyright © 2016 mohamedadly. All rights reserved.
//

import Foundation

public class DataValidator{
    
    
    //validate email
    class func isEmailValid(email : String) -> Bool{
        let laxString : String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", laxString)
        return emailTest.evaluateWithObject(email) && email.characters.count <= 128
    }
    
    //validate password
    class func isPasswordValid(password : String) -> Bool{
        return password.characters.count <= 32
    }

}