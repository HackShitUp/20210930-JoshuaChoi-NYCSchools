//
//  SchoolsViewController.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit
import NavigationTransitionController



/**
 Abstract: View Controller class that displays a list of NYC schools
 */
class SchoolsViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the pagination to 10 items per result
        self.limit = 10
        
        view.backgroundColor = .red
    }
    

    
    /// Load all of the schools
    /// - Parameter sender: Any object that calls this method
    @objc fileprivate func loadData(_ sender: Any) {
        // MARK: - Service
        Service.shared.fetchSchools(limit: self.limit) { (schools: [School]?, error: Error?) in
            if error == nil {
                print("Schools: \(schools)")
                
            } else {
                print("\(self.classForCoder)/\(#line) - Error: \(error?.localizedDescription as Any)")
            }
        }
    }

}
