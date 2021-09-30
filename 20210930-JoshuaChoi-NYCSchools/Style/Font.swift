//
//  Font.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit



/**
 Abstract: Custom class used to return various fonts with the app's key display font.
 */
class Font {
    
    /**
     MARK: - Size
     Enum for the Font class used to set preset font sizes
     */
    enum Size: CGFloat, CaseIterable {
        /// 13.0
        case footnote = 13.0
        /// 16.0
        case body = 16.0
        /// 20.0
        case heading = 20.0
        /// 30.0
        case large = 30.0
    }
    
    /**
     MARK: - Weight
     Enum for the Font class used to set preset font weights
     */
    enum Weight: Int, CaseIterable {
        case medium = 0
        case semibold = 1
        case bold = 2
        case black = 3
        
        /// Return the UIFont.Weight
        var weight: UIFont.Weight {
            get {
                switch self {
                case .medium:
                    return UIFont.Weight.medium
                case .semibold:
                    return UIFont.Weight.semibold
                case .bold:
                    return UIFont.Weight.bold
                case .black:
                    return UIFont.Weight.black
                }
            }
        }
    }
    
    /// Returns a UIFont object with the specified Weight and Size enum values
    /// - Parameters:
    ///   - weight: A Weight enum value
    ///   - size: A Size enum value
    ///   - overrideRawSize: An optional CGFloat representing the UIFont's size
    ///   - isItalic: A Boolean value that indicates whether the font should be italicized or not. Defaults to FALSE
    /// - Returns: A UIFont object
    static func with(_ weight: Weight, _ size: Size, overrideRawSize: CGFloat? = nil, isItalic: Bool = false) -> UIFont {
        return UIFont.systemFont(ofSize: size.rawValue, weight: weight.weight)
    }
}
