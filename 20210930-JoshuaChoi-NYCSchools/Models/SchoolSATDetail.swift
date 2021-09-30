//
//  SchoolSATDetail.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit



/**
 Abstract: Model outlining the details of a given's school's SAT details
 */
struct SchoolSATDetail: Codable {
    
    // MARK: - Class Vars
    
    var id,
        name,
        testTakerCount,
        readingAvgScore,
        mathAvgScore,
        writingAvgScore: String?
    
    
    private enum CodingKeys: String, CodingKey {
        case id = "dbn"
        case name = "school_name"
        case testTakerCount = "num_of_sat_test_takers"
        case readingAvgScore = "sat_critical_reading_avg_score"
        case mathAvgScore = "sat_math_avg_score"
        case writingAvgScore = "sat_writing_avg_score"
    }
    
}
