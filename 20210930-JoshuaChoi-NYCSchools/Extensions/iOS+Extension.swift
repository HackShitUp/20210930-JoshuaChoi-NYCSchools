//
//  iOS+Extension.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit



// MARK: - NSMutableAttributedString
extension NSMutableAttributedString {
    /// Applies an NSMutableParagraphStyle with specified properties to the mutable attributed string
    /// - Parameters:
    ///   - lineHeightMultiple: A CGFloat value representing the line height multiple
    ///   - fontForLineHeight: An optional UIFont used to set the paragraph style's min/max line height — by default this value is nil which implies that the largest font (based on point size) will be applied to the attributed string
    ///   - lineBreakMode: An optional NSLineBreakMode object
    ///   - textAlignment: An optional NSTextAlignment object
    func applyParagraphStyle(lineHeightMultiple: CGFloat = 1.0,
                             fontForLineHeight: UIFont? = nil,
                             lineBreakMode: NSLineBreakMode? = nil,
                             textAlignment: NSTextAlignment? = nil) {
        // Unwrap the attributed text and only execute the following codeblock if the length is > 0
        guard let attributedText = self.mutableCopy() as? NSAttributedString, attributedText.length > 0 else {
            return
        }
        
        // Store the font for the line height - if this value is nil, we set it
        var font: UIFont? = fontForLineHeight
        
        // Enumerate through the attributes
        attributedText.enumerateAttributes(in: NSRange(0..<attributedText.length), options: []) {
            (attributes, range, stop) in
            // Iterate through each of the attributes and get the font
            attributes.forEach { (key: NSAttributedString.Key, value: Any) in
                if key == NSAttributedString.Key.font, let textFont = value as? UIFont {
                    // Set the largest font
                    if font == nil {
                        font = textFont
                    } else if textFont.pointSize > font?.pointSize ?? textFont.pointSize {
                        font = textFont
                    }
                }
            }
        }
        
        // MARK: - NSMutableParagraphStyle
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        if let font = font {
            paragraphStyle.minimumLineHeight = font.lineHeight
            paragraphStyle.maximumLineHeight = font.lineHeight
        }
        if let lineBreakMode = lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }
        if let textAlignment = textAlignment {
            paragraphStyle.alignment = textAlignment
        }
        self.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: self.length))
    }
}



// MARK: - UICollectionView
extension UICollectionView {
    /// Returns the last section in the collection view
    var lastSection: Int {
        get {
            return Int(numberOfSections - 1)
        }
    }
}



// MARK: - UILabel
extension UILabel {
    /// Reset the UILabel's NSAttributedString's substrings whose foreground colors match a specified array of colors with a new foreground color
    /// - Parameters:
    ///   - containingColors: An array of UIColor values representing the colors found in each substring that we should replace with — defaults to black and white colors
    ///   - updatedColor: A UIColor value representing the color to replace with in the specified substring - defaults to black (with the trait collection supporting light/dark mode)
    func resetAttributedStringForegroundColors(containingColors: [UIColor] = [Color(.Black, adoptDarkMode: false), Color(.White, adoptDarkMode: false)], updatedColor: UIColor = Color(.Black)) {
        // Unwrap the attributed text
        guard let attributedText = attributedText?.mutableCopy() as? NSAttributedString else {
            return
        }
        
        // Create the new NSMutableAttributedString with the attributed text
        let labelAttributedString = NSMutableAttributedString(attributedString: attributedText)
        // Enumerate through the attributes
        attributedText.enumerateAttributes(in: NSRange(0..<attributedText.length), options: []) {
            (attributes, range, stop) in
            // Iterate through each of the attributes
            attributes.forEach { (key: NSAttributedString.Key, value: Any) in
                // If we've found the foreground color, we need to add the attributed string's foreground color with the new color at the specified range
                if key == NSAttributedString.Key.foregroundColor,
                   let foregroundColor = value as? UIColor,
                   foregroundColor != Color(.Accent),
                    containingColors.contains(foregroundColor) {
                    labelAttributedString.addAttributes([.foregroundColor: updatedColor], range: range)
                }
            }
        }
        // Set the attributed text with the mutated attributed string
        if let attributedLabel = self as? AttributedLabel {
            attributedLabel.text = labelAttributedString
        } else {
            self.attributedText = labelAttributedString
        }
    }
}



// MARK: - UIScrollView
extension UIScrollView {
    /// Determine if the scroll view reached the end
    var isAtEndOfScroll: Bool {
        get {
            return contentOffset.y >= contentSize.height - frame.size.height
        }
    }
}



// MARK: - UIView
extension UIView {
    /**
     NOTE: The MVC principle designed by Apple wants us to access views from the view controller class. This method allows us to access the parent view controller class using the view.
     ie: if let parentViewController = view.isViewController {...}
     */
    var inViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}



// MARK: - UIViewController
extension UIViewController {
    
    /// Pagination
    private struct Pagination {
        static var limit = "limit"
        static var offset = "skip"
        static var isLoadingData = "isLoadingData"
    }
    
    /// Boolean used to indicate whether we're loading data or not
    var isLoadingData: Bool {
        set(value) {
            objc_setAssociatedObject(self, &Pagination.isLoadingData, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &Pagination.isLoadingData) as? Bool ?? false
        }
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
    var offset: Int {
        set(value) {
            objc_setAssociatedObject(self, &Pagination.offset, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            // Return the stored offset or the default offset of 0
            return objc_getAssociatedObject(self, &Pagination.offset) as? Int ?? 0
        }
    }
}








