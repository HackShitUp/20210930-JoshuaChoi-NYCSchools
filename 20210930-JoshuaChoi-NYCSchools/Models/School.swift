//
//  School.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit



/**
 Abstract: Model outlining the details of a given's school's SAT details
 */
struct School: Codable {
    
    // MARK: - Class Vars
    
    var id,
        name,
        description,
        email,
        website,
        nta,
        borough,
        phoneNumber: String?
    
    
    /// Determines if this School was favorited by the user — stored locally (this would need to be synced to the database if this were a real product)
    var isFavorite: Bool {
        get {
            return FavoriteCache.isFavorited(schoolId: self.id)
        }
    }
    
    /// Rename some of the properties here so they're easier to work with
    private enum CodingKeys: String, CodingKey {
        case id = "dbn"
        case name = "school_name"
        case description = "overview_paragraph"
        case phoneNumber = "phone_number"
        case email = "school_email"
        case website, nta, borough
    }
}
