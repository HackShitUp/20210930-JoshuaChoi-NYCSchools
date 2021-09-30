//
//  Config.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit



/**
 Abstract: Class managing the app's configurations — typicaly, this should be done more securely rather than as a file (I'd typically use Cocoapods-Keys but that's a hassle to setup for a project of this scope — also view https://nshipster.com/secrets/ on best practices)
 */
class Config {
    /// API
    struct API {
        /// URL path of the end point
        static let schoolListURLPath: String = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
        static let schoolSATDetailURLPath: String = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json"
    }
}
