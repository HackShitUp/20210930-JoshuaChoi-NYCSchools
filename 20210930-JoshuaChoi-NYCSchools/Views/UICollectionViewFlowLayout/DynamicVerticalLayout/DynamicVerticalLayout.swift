//
//  DynamicVerticalLayout.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit



/**
 Abstract: UICollectionViewFlowLayout subclass for dynamic cell sizes
 */
class DynamicVerticalLayout: UICollectionViewFlowLayout {
    
    // MARK: - Class Vars
    
    // MARK: - Init
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    fileprivate func setup() {
        // Configure the layout
        scrollDirection = .vertical
        sectionInset = .zero
        minimumInteritemSpacing = 0.0
        minimumLineSpacing = 0.0
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
}
