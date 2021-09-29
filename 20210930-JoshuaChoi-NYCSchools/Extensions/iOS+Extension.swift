//
//  iOS+Extension.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit



// MARK: - UIViewController
extension UIViewController {
    
    /// Pagination
    private struct Pagination {
        static var limit = "limit"
        static var skip = "skip"
    }

    /// Initialized Int value representing the maximum number of objects to return in a query
    var limit: Int {
        set(value) {
            objc_setAssociatedObject(self, &Pagination.limit, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            // Return the stored limit or the default limit of 50
            return objc_getAssociatedObject(self, &Pagination.limit) as? Int ?? 50
        }
    }
    
    /// Initialized Int value representing the total number of objects to skip before returning them in a query
    var skip: Int {
        set(value) {
            objc_setAssociatedObject(self, &Pagination.skip, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            // Return the stored skip or the default skip of 0
            return objc_getAssociatedObject(self, &Pagination.skip) as? Int ?? 0
        }
    }
}
