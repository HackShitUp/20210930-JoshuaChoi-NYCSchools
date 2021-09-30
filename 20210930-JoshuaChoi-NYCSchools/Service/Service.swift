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
    
    /// Singleton init
    static let shared: Service = Service()
    
    /// MARK: - Init
    private override init() {
        super.init()
    }

    /// Returns a list of schools
    /// - Parameters:
    ///   - offset: An Int value representing the total number of objects to offset from the results
    ///   - limit: An Int value representing the maximum number of objects to return
    ///   - completion: Returns an optional array of School objects or an optional Error if the request fails
    open func fetchSchools(offset: Int = 0,
                           limit: Int = 10,
                           completion: ((_ schools: [School]?, _ error: Error?) -> ())? = nil) {
        
        // MARK: - URL
        guard let url = URL(string: "\(Config.API.schoolListURLPath)?$offset=\(offset)&$limit=\(limit)") else {
            // Pass the values in the completion
            completion?(nil, CustomError(message: "\(self.classForCoder)/\(#line) - Error defining URL"))
            return
        }
        
        // MARK: - URLRequest
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        // MARK: - URLSession
        URLSession.shared.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                // Unwrap the data
                guard let data = data else {
                    // Pass the values in the completion
                    completion?(nil, CustomError(message: "\(self.classForCoder)/\(#line) - Error getting the request response data"))
                    return
                }
                
                // Decode the JSON data
                do {
                    let schools = try JSONDecoder().decode([School].self, from: data)
                    // Pass the values in the completion
                    completion?(schools, nil)
                
                } catch let decoderError {
                    // Pass the values in the completion
                    completion?(nil, CustomError(message: "\(self.classForCoder)/\(#line) - Decoder Error: \(decoderError.localizedDescription)"))
                }
                
            } else {
                // Pass the values in the completion
                completion?(nil, CustomError(message: "\(self.classForCoder)/\(#line) - Error: \(error?.localizedDescription as Any)"))
            }
        }.resume()
    }
    
    
    /// Fetch a school's SAT details
    /// - Parameters:
    ///   - school: An optional School object
    ///   - completion: Returns an optional SAT object or an optional Error if the request response fails
    func fetchSchoolSATDetails(school: School?, completion: ((_ schoolSATDetails: [SchoolSATDetail]?, _ error: Error?) -> ())? = nil) {
        // MARK: - URL
        guard let id = school?.id,
                let url = URL(string: "\(Config.API.schoolSATDetailURLPath)?dbn=\(id)") else {
            // Pass the values in the completion
            completion?(nil, CustomError(message: "\(self.classForCoder)/\(#line) - Error defining URL"))
            return
        }
        
        // MARK: - URLRequest
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        // MARK: - URLSession
        URLSession.shared.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                // Unwrap the data
                guard let data = data else {
                    // Pass the values in the completion
                    completion?(nil, CustomError(message: "\(self.classForCoder)/\(#line) - Error getting the request response data"))
                    return
                }
                
                // Decode the JSON data
                do {
                    let schoolSATDetails = try JSONDecoder().decode([SchoolSATDetail].self, from: data)
                    // Pass the values in the completion
                    completion?(schoolSATDetails, nil)
                
                } catch let decoderError {
                    // Pass the values in the completion
                    completion?(nil, CustomError(message: "\(self.classForCoder)/\(#line) - Decoder Error: \(decoderError.localizedDescription)"))
                }
                
            } else {
                // Pass the values in the completion
                completion?(nil, CustomError(message: "\(self.classForCoder)/\(#line) - Error: \(error?.localizedDescription as Any)"))
            }
        }.resume()
    }
}
