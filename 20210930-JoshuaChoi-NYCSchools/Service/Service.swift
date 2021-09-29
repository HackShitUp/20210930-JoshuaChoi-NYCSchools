//
//  Service.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit



/**
 Abstract: Singleton class used to make service calls
 */
class Service: NSObject {

    // MARK: - Class Vars
    
    /// Server URL
    let serverURLPath: String = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
    
    /// Singleton init
    static let shared: Service = Service()
    
    /// MARK: - Init
    private override init() {
        super.init()
    }
}


extension Service {
    
    /// Get schools for a given Service
    /// - Parameter completion: Returns an optional array of School objects or an optional Error if the request fails
    open func fetchSchools(limit: Int, completion: ((_ schools: [School]?, _ error: Error?) -> ())? = nil) {
        
        // MARK: - URL
        guard let url = URL(string: self.serverURLPath) else {
            
            return
        }
    }
}
