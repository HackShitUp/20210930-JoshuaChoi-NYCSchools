//
//  SchoolSATDetailCell.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit



/**
 Abstract: Class to display data from a School's SAT details
 */
class SchoolSATDetailCell: UICollectionViewCell {
    
    // MARK: - Class Vars
    
    static let reuseIdentifier: String = "SchoolSATDetailCell"
    static let size: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 50.0)
    
    /// SchoolSATDetail object
    var schoolSATDetail: SchoolSATDetail?
    
    // MARK: - AttributedLabel
    let label: AttributedLabel = AttributedLabel(frame: .zero)
    
    
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
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0).isActive = true
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
    }
    
    /// Update the contents of this cell class with a School
    /// - Parameter schoolSATDetail: An optional SchoolSATDetail object
    func updateContent(schoolSATDetail: SchoolSATDetail?) {
        // Set the SchoolSATDetailObject
        self.schoolSATDetail = schoolSATDetail
        
        // MARK: - NSMutableAttributedString
        let labelAttributedString = NSMutableAttributedString()
        
        // Set the schools's name
        if let name = schoolSATDetail?.name {
            labelAttributedString.append(NSAttributedString(string: name, attributes: [.foregroundColor: Color(.Black), .font: Font.with(.bold, .body)]))
        }
        // Set the num of test takers
        if let testTakerCount = schoolSATDetail?.testTakerCount {
            labelAttributedString.append(NSAttributedString(string: "\nNumber of Test Takers: ", attributes: [.foregroundColor: Color(.LightGray), .font: Font.with(.medium, .body)]))
            labelAttributedString.append(NSAttributedString(string: "\(testTakerCount) People", attributes: [.foregroundColor: Color(.Black), .font: Font.with(.semibold, .body)]))
        }
        // Set the average math score
        if let mathAvgScore = schoolSATDetail?.mathAvgScore {
            labelAttributedString.append(NSAttributedString(string: "\nAverage Math Score: ", attributes: [.foregroundColor: Color(.LightGray), .font: Font.with(.medium, .body)]))
            labelAttributedString.append(NSAttributedString(string: "\(mathAvgScore) out of 800", attributes: [.foregroundColor: Color(.Black), .font: Font.with(.semibold, .body)]))
        }
        // Set the average reading score
        if let readingAvgScore = schoolSATDetail?.readingAvgScore {
            labelAttributedString.append(NSAttributedString(string: "\nAverage Reading Score: ", attributes: [.foregroundColor: Color(.LightGray), .font: Font.with(.medium, .body)]))
            labelAttributedString.append(NSAttributedString(string: "\(readingAvgScore) out of 800", attributes: [.foregroundColor: Color(.Black), .font: Font.with(.semibold, .body)]))
        }
        // Set the average math score
        if let writingAvgScore = schoolSATDetail?.writingAvgScore {
            labelAttributedString.append(NSAttributedString(string: "\nAverage Writing Score: ", attributes: [.foregroundColor: Color(.LightGray), .font: Font.with(.medium, .body)]))
            labelAttributedString.append(NSAttributedString(string: "\(writingAvgScore) out of 800", attributes: [.foregroundColor: Color(.Black), .font: Font.with(.semibold, .body)]))

        }
        
        // Add the paragraph style
        labelAttributedString.applyParagraphStyle()
        
        // Set the label's attributed text
        label.text = labelAttributedString
    }
}
