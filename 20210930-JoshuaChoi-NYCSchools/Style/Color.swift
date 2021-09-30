//
//  Color.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit



/**
 MARK: - Hex
 Enum with raw values of a color's hex-values.
 */
enum Hex: String, CaseIterable {
    case Accent = "154C8A"
    case Black = "000000"
    case Blue = "0098FD"
    case Clear = "E0E0E0"
    case DarkGray = "2E2D30"
    case Gainsboro = "E5E5EA"
    case LightGray = "8E8E93"
    case White = "FFFFFF"
    case Infrared = "FF0055"
}



// MARK: - Color
class Color: UIColor {
    
    /// Return all Hex colors as UIColors
    static var allHexColors: [UIColor] {
        get {
            // Return all the colors
            return Hex.allCases.map { (hex: Hex) -> UIColor in
                return Color(hex)
            }
        }
    }
    
    /// MARK: - Init
    /// - Parameter hex: A Hex enum used to define the UIColor by using it's string's raw value which represents the color's hex value.
    /// - Parameter alpha: An alpha value for the UIColor.
    /// - Parameter adoptDarkMode: A Boolean value used to determine if we should swap any white or black colors.
    public convenience init(_ hex: Hex, _ alpha: CGFloat = 1.0, adoptDarkMode: Bool = true) {
        // Prune the string value from the HEX enum and swap out colors based on whether we're supporting dark mode.
        var string: String = hex.rawValue
        
        // MARK: - Hex
        switch hex {
        case .White, .Clear:
            string = UITraitCollection.current.userInterfaceStyle == .dark && adoptDarkMode ? Hex.Black.rawValue : Hex.White.rawValue
        case .Black:
            string = UITraitCollection.current.userInterfaceStyle == .dark && adoptDarkMode ? Hex.White.rawValue : Hex.Black.rawValue
        case .Gainsboro:
            string = UITraitCollection.current.userInterfaceStyle == .dark && adoptDarkMode ? Hex.DarkGray.rawValue : Hex.Gainsboro.rawValue
        case .DarkGray:
            string = UITraitCollection.current.userInterfaceStyle == .dark && adoptDarkMode ? Hex.Gainsboro.rawValue : Hex.DarkGray.rawValue
        default: break;
        }
        
        // Get rid of any white spaces and any #'s
        string = string.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "").uppercased()
        
        var RGB: UInt64 = 0
        Scanner(string: string).scanHexInt64(&RGB)

        // MARK: - UIColor
        self.init(
            red: CGFloat((RGB & 0xFF0000) >> 16)/255.0,
            green: CGFloat((RGB & 0x00FF00) >> 8)/255.0,
            blue: CGFloat(RGB & 0x0000FF)/255.0,
            alpha: hex == .Clear ? 0.0 : CGFloat(alpha >= 0.0 && alpha <= 1.0 ? alpha : 1.0)
        )
    }
}
