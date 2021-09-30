//
//  AttributedLabel.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit
import TTTAttributedLabel
import SafariServices



/**
 Abstract: Subclass of the TTTAttributedLabel object used to detect URL links
 */
class AttributedLabel: TTTAttributedLabel {
    
    // MARK: - Class Vara
    
    /// NSAttributedString for the expandable truncation token
    static let truncationTokenAttributedString = NSAttributedString(string: "...more", attributes: [.foregroundColor: Color(.LightGray), .font: Font.with(.bold, .footnote)])
    
    /// UIColor of the attributed text
    var attributedColor: UIColor = Color(.Accent)
    
    /// Initialized Dictionary for the link attributes
    var labelLinkAttributes: [CFString: Any] {
        get {
            return [kCTForegroundColorAttributeName: attributedColor]
        }
    }
    
    /// Initialized Dictionary for the active link attributes
    var labelActiveLinkAttributes: [CFString: Any] {
        get {
            return [kCTForegroundColorAttributeName: attributedColor.withAlphaComponent(0.20)]
        }
    }
    
    /// Initialized String value
    var string: String?
    
    // MARK: - TTTAttributedLabel
    override var text: Any! {
        didSet {
            // Get the String
            let string: String = (text as? NSMutableAttributedString)?.string ?? (text as? NSAttributedString)?.string ?? text as? String ?? ""
            
            // Store the string
            self.string = string
            
            // MARK: - TTTAttributedLabel
            // Set the text attributes
            self.linkAttributes = self.labelLinkAttributes
            self.activeLinkAttributes = self.labelActiveLinkAttributes
            
            // Detech phone numbers
            self.defineLinkAttributes(string, types: [.phoneNumber])
        }
    }
    
    /// Initialized Bollean used to determine if this class should enable long press to copy the text
    var isCopyContentEnabled: Bool = false {
        didSet {
            if isCopyContentEnabled {
                // MARK: - UILongPressGestureRecognizer
                let pressToCopyGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(copyText(_:)))
                pressToCopyGestureRecognizer.cancelsTouchesInView = false
                self.isUserInteractionEnabled = true
                self.addGestureRecognizer(pressToCopyGestureRecognizer)
            }
        }
    }
    
    
    // - Tag
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // - Tag
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy(_:))
    }
    
    // - Tag
    override func copy(_ sender: Any?) {
        if let message = text as? String  {
            UIPasteboard.general.string = message
        } else {
            print("\(#file)/\(#line) - Couldn't unwrap \(classForCoder)'s 'text' as a String value.")
        }
    }
    
    /// MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        // self
        frame = bounds
        backgroundColor = Color(.Clear)
        clipsToBounds = true
        preferredMaxLayoutWidth = frame.width
        
        // MARK: - TTTAttributedLabel
        textColor = Color(.Black)
        font = Font.with(.medium, .body)
        longPressGestureRecognizer.isEnabled = false
        linkAttributes = labelLinkAttributes
        activeLinkAttributes = labelActiveLinkAttributes
        enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
        delegate = self
    }
    
    /// Called when the user presses on a UILabel to "copy" the text.
    /// - Parameter sender: A UILongPressGestureRecognizer object that calls this method.
    @objc fileprivate func copyText(_ sender: UILongPressGestureRecognizer) {
        // Unwrap the sender's view and the sender's superview
        guard let senderView = sender.view, let senderSuperview = senderView.superview else {
            print("\(#file)/\(#line) - Exiting method because we couldn't unwrap the sender's view and its superview.")
            return
        }
        
        switch sender.state {
        case .began:
            // MARK: - UIMenuController
            let menuController = UIMenuController.shared
            menuController.showMenu(from: senderSuperview, rect: senderView.frame)
            senderView.becomeFirstResponder()
        default: break;
        }
    }
    
    /// Define link attributes for a given string using an AttributedLabelData enum or an NSTextCheckingResult.CheckingType enum
    /// - Parameter string: An optional String value representing the String to parse
    /// - Parameter types: An NSTextCheckingResult.CheckingType enum value used to check for dates, phone numbers, or addresses
    func defineLinkAttributes(_ string: String? = nil, types: NSTextCheckingResult.CheckingType? = nil) {
        // Unwrap the string to define the username or hashtag link
        guard let string = string, let types = types else {
            print("\(#file)/\(#line) - Invalid String parameter")
            return
        }
        
        /**
         Here, we're detecting all phone numbers, dates, and addresses using Apple's built-in NSTextCheckingResultType enums
         */
        
        // MARK: - NSDataDetector
        let detector = try? NSDataDetector(types: types.rawValue)

        // MARK: - NSTextCheckingResult
        // Define the text checking result and iterate through each result found in the string
        let textCheckingResults = detector?.matches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.utf16.count))
        textCheckingResults?.forEach({ (result: NSTextCheckingResult) in
            // MARK: - NSTextCheckingResult
            switch types {
            case [.phoneNumber]:
                // Add the URL scheme to the label and handle it in the TTTAttributedLabelDelegate methods
                addLink(toPhoneNumber: result.phoneNumber, with: result.range)
            case [.date]:
                // Add the URL scheme to the label and handle it in the TTTAttributedLabelDelegate methods
                addLink(to: result.date, with: result.range)
            case [.address]:
                // Add the URL scheme to the label and handle it in the TTTAttributedLabelDelegate methods
                addLink(toAddress: result.components, with: result.range)
            default: break;
            }
        })
    }
}



// MARK: - TTTAttributedLabelDelegate
extension AttributedLabel: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        // Unwrap the URL and the UIViewController
        guard url != nil, let viewController = self.inViewController else {
            return
        }
        
        // Open Safari for the URL
        let safariVC = SFSafariViewController(url: url)
        viewController.present(safariVC, animated: true)
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
        // Unwrap the phoneNumber
        guard let phoneNumber = phoneNumber else {
            return
        }
        
        // Unwrap the phone number
        guard let url = URL(string: "tel://\(phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: ""))"), UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        // Call this phone number
        UIApplication.shared.open(url)
    }
}


