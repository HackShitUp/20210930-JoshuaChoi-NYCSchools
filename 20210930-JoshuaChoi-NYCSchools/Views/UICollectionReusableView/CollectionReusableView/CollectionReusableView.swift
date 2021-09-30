//
//  CollectionReusableView.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit
import NVActivityIndicatorView




/**
 Abstract: Custom UICollectionReusableView displayed across the app to differentiate items in a collection view section. This class enables presentation of a section's title with an indicator to animate loading indicators for pagination (infinite scroll)
 */
class CollectionReusableView: UICollectionReusableView {
    
    // MARK: - Class Vars

    static let reuseIdentifier: String = "CollectionReusableView"
    static let size: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 50.0)
    let label: UILabel = UILabel(frame: .zero)
    let indicatorView: NVActivityIndicatorView = NVActivityIndicatorView(frame: .zero)
    
    
    
    /// MARK: - Init
    /// - Parameter frame:
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
        
    /// Setup this view's interface - we use `fileprivate` to prevent modifications for this view
    fileprivate func setup() {
        // Setup the label
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingMiddle
        
        // Setup the indicator view
        addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicatorView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        indicatorView.color = Color(.Accent)
        indicatorView.padding = 8.0
        indicatorView.type = .circleStrokeSpin
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset the view's contents
        animate(false)
        label.attributedText = nil
    }
    
    /// Update this class' label's text
    /// - Parameters:
    ///   - labelAttributedString: An NSAttributedString object
    ///   - textAlignment: An NSTextAlignment
    open func updateContent(labelAttributedString: NSAttributedString, textAlignment: NSTextAlignment = .left) {
        label.textAlignment = textAlignment
        label.attributedText = labelAttributedString
    }
    
    /// Animate this class' indicator
    /// - Parameter isLoading: A Boolean value indicating whether this class' indicator should animate or not
    open func animate(_ isLoading: Bool) {
        switch isLoading {
        case true:
            // Begin the animation
            DispatchQueue.main.async {
                self.indicatorView.alpha = 1.0
                self.indicatorView.startAnimating()
            }
        case false:
            // Stop the animation but also delay it
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.indicatorView.stopAnimating()
                self.indicatorView.alpha = 0.0
            }
        }
    }
}
