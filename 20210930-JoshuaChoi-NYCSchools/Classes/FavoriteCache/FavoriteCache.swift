//
//  FavoriteCache.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit


/**
 Abstract: Class that manages enabling the user to favorite a school
 */
class FavoriteCache {
    
    // MARK: - Class Vars
    
    /// Key for UserDefaults
    private static let cacheKey: String = "favorited-school-ids"
    
    /// Returns whether a School was favorited
    static func isFavorited(schoolId: String?) -> Bool {
        guard let id = schoolId else {
            return false
        }
        
        if let ids = UserDefaults.standard.object(forKey: FavoriteCache.cacheKey) as? [String],
           ids.contains(where: {$0 == id}) {
            return true
        } else {
            return false
        }
    }
    
    /// Update the UserDefaults with the favorited school by adding/removing it from the cache
    /// - Parameter schoolId: An optional String value representing the school's id
    static func update(schoolId: String?, completion: ((_ success: Bool, _ isFavorited: Bool) -> ())? = nil) {
        guard let id = schoolId else {
            completion?(false, false)
            return
        }
        
        if var ids = UserDefaults.standard.object(forKey: FavoriteCache.cacheKey) as? [String] {
            // Remove or add the school as a favorite
            if ids.contains(where: {$0 == id}) {
                // Remove any instances of the school
                ids = ids.filter({$0 != id})
                UserDefaults.standard.set(ids, forKey: FavoriteCache.cacheKey)
                completion?(true, false)
            } else {
                // Add the new id
                ids.append(id)
                UserDefaults.standard.set(ids, forKey: FavoriteCache.cacheKey)
                completion?(true, true)
            }
            
        } else {
            // Set the initial array
            UserDefaults.standard.set([id], forKey: FavoriteCache.cacheKey)
            completion?(true, true)
        }
    }
}
