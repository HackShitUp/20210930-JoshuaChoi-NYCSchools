//
//  SchoolCell.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit


// MARK: - SchoolCellDelegate
protocol SchoolCellDelegate {
    /// Called whenever the user favorited a school
    func schoolCellFavoritedSchool(_ school: School?)
}



/**
 Abstract: UICollectionViewCell class that displays the contents of a given School
 */
class SchoolCell: UICollectionViewCell {
    
    // MARK: - Class Vars
    
    static let reuseIdentifier: String = "SchoolCell"
    static let size: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 50.0)
    
    
    var school: School?
    let label: AttributedLabel = AttributedLabel(frame: .zero)
    var favoriteButton: UIButton = UIButton(frame: .zero)
    var delegate: SchoolCellDelegate?
    
    
    // - Tag
    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? Color(.Gainsboro, 0.50) : Color(.Clear)
        }
    }
    
    
    
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
    
    fileprivate func setup() {
        backgroundColor = Color(.White)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // Setup the label
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0).isActive = true
        label.textAlignment = .left
        
        // Setup the favoriteButton
        contentView.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        favoriteButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 16.0).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        favoriteButton.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteSchool(_:)), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset the favorite button
        favoriteButton.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.tintColor = Color(.Black)

    }
    
    // MARK: - UITraitCollection
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Only execute the following codeblock if the trait collection changed
        guard traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle else {
            return
        }
        
        // Reset the view objects' necesarry colors
        backgroundColor = Color(.White)
        label.resetAttributedStringForegroundColors()
        favoriteButton.tintColor = school?.isFavorite == true ? Color(.Infrared) : Color(.Black)
    }
    
    
    /// Called whenever a school was favorited
    /// - Parameter sender: Any object that calls this method
    @objc fileprivate func favoriteSchool(_ sender: Any) {
        // MARK: - UINotificationFeedbackGenerator
        let notificationFeedbackGenerator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.notificationOccurred(.success)
        
        // MARK: - FavoriteCache
        FavoriteCache.update(schoolId: school?.id) { (success: Bool, isFavorited: Bool) in
            if success {
                // Call the delegate
                self.delegate?.schoolCellFavoritedSchool(self.school)
                
                // Update the button
                DispatchQueue.main.async {
                    self.favoriteButton.setImage(UIImage(systemName: isFavorited ? "heart.fill" : "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
                    self.favoriteButton.tintColor = isFavorited ? Color(.Infrared) : Color(.Black)
                }
            }
        }
    }
    
    /// Update the contents of this cell class with a School
    /// - Parameters:
    ///   - school: An optional School object
    ///   - shouldTruncateText: A Boolean indicating whether we should truncate this cell's text
    ///   - delegate: An optional SchoolCellDelegate
    func updateContent(school: School?, shouldTruncateText: Bool = true, delegate: SchoolCellDelegate? = nil) {
        // Set the school object
        self.school = school
        
        // Set the delegate
        self.delegate = delegate
        
        // Determine if this school was favorited
        let isFavorited = school?.isFavorite == true
        // Update the button accordingly
        favoriteButton.setImage(UIImage(systemName: isFavorited ? "heart.fill" : "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.tintColor = isFavorited ? Color(.Infrared) : Color(.Black)
        
        // MARK: - NSMutableAttributedString
        let labelAttributedString = NSMutableAttributedString()
        
        // Get the school's name
        if let name = school?.name {
            labelAttributedString.append(NSAttributedString(string: name, attributes: [.foregroundColor: Color(.Black), .font: Font.with(.bold, .body)]))
        }
        // Get the school's nta
        if let nta = school?.nta {
            labelAttributedString.append(NSAttributedString(string: "\n\(nta)", attributes: [.foregroundColor: Color(.LightGray), .font: Font.with(.semibold, .footnote)]))
        }
        // Get the school's website
        if let website = school?.website {
            labelAttributedString.append(NSAttributedString(string: "\n\(website)", attributes: [.foregroundColor: Color(.Black), .font: Font.with(.semibold, .footnote)]))
        }
        // Get the schools' phone number
        if let phoneNumber = school?.phoneNumber {
            labelAttributedString.append(NSAttributedString(string: "\n\(phoneNumber)", attributes: [.foregroundColor: Color(.Black), .font: Font.with(.semibold, .footnote)]))
        }
        // Get the school's overview
        if let description = school?.description {
            labelAttributedString.append(NSAttributedString(string: "\n\(description)", attributes: [.foregroundColor: Color(.Black), .font: Font.with(.medium, .footnote)]))
        }
        
        // Add the paragraph style
        labelAttributedString.applyParagraphStyle()
        
        // Set the label's attributed text
        label.numberOfLines = shouldTruncateText ? 6 : 0
        label.lineBreakMode = shouldTruncateText ? .byTruncatingTail : .byWordWrapping
        label.attributedTruncationToken = shouldTruncateText ? NSAttributedString(string: "...more", attributes: [.foregroundColor: Color(.LightGray), .font: Font.with(.bold, .footnote)]) : nil
        label.text = labelAttributedString
    }
}
