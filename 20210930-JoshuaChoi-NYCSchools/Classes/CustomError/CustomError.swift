//
//  Custom.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//  Copyright © 2021 Joshua Choi. All rights reserved.
//

import UIKit



/**
 Abstract: Custom Error object used to log errors from both Parse-Server and this app. Visit the link below for error codes:
 https://docs.parseplatform.org/ios/guide/#error-codes
 */
class CustomError: NSObject, LocalizedError {
    
    // MARK: - Class Vars
    
    /// String value of the error message
    var message: String = ""
    
    /// Override of LocalizedError object variable
    override var description: String {
        get {
            return message
        }
    }
    
    // MARK: - LocalizedError
    var errorDescription: String? {
        get {
            return description
        }
    }
    
    /// MARK: - Init
    /// - Parameter errorMessage: A String value representing the
    init(message: String) {
        self.message = message
    }
}
