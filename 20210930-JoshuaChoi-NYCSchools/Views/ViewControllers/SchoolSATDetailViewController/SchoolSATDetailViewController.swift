//
//  SchoolSATDetailViewController.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit
import NavigationTransitionController



/**
 Abstract: Sections for the collection view
 */
enum SchoolSection: String, CaseIterable {
    case school = "School"
    case details = "SAT Details"
}



// MARK: - SchoolSATDetailViewControllerDelegate
protocol SchoolSATDetailViewControllerDelegate {
    /// Called whenever the user favorited/unfavorited a School — useful when we want to also update the SchoolsViewController class's data source to persist the favorite state
    func schoolSATDetailViewControllerFavoriteChanged(_ school: School?)
}



/**
 Abstract: View Controller class that displays a list of NYC schools
 */
class SchoolSATDetailViewController: UIViewController {

    // MARK: - Class Vars
    
    // MARK: - School
    var school: School?
    
    // MARK: - SchoolSATDetailViewControllerDelegate
    var delegate: SchoolSATDetailViewControllerDelegate?
    
    // MARK: - SchoolSATDetail
    var schoolSATDetails: [SchoolSATDetail] = []
    
    // MARK: - SchoolSection
    let schoolSections: [SchoolSection] = SchoolSection.allCases
    
    // MARK: - UIBarButtonItem
    var backItem: UIBarButtonItem!
    
    // MARK: - LinearRefresher
    let linearRefresher: LinearRefresher = LinearRefresher()
    
    // MARK: - UICollectionView
    let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    /// MARK: - Init
    /// - Parameters:
    ///   - school: An optional School object
    ///   - delegate: An optional SchoolSATDetailViewControllerDelegate
    init(school: School?, delegate: SchoolSATDetailViewControllerDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        // Set the school
        self.school = school
        // Set the delegate
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    // MARK: - View Controller Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set the background colors
        navigationController?.view.backgroundColor = Color(.White)
        view.backgroundColor = Color(.White)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Set the background colors
        navigationController?.view.backgroundColor = Color(.White)
        view.backgroundColor = Color(.White)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the pagination values
        self.offset = 0
        self.limit = 10
        
        // Setup the back item
        backItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leaveViewController(_:)))
        backItem.tintColor = Color(.Accent)
        
        // Setup the navigation bar
        navigationItem.title = "SAT Details"
        navigationItem.leftBarButtonItem = backItem
        navigationController?.navigationBar.barTintColor = Color(.White)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Color(.Accent), .font: Font.with(.black, .body)]
        
        // Setup the collection view
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.collectionViewLayout = DynamicVerticalLayout()
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.register(SchoolCell.self, forCellWithReuseIdentifier: SchoolCell.reuseIdentifier)
        collectionView.register(SchoolSATDetailCell.self, forCellWithReuseIdentifier: SchoolSATDetailCell.reuseIdentifier)
        collectionView.register(CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionReusableView.reuseIdentifier)
        collectionView.register(CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionReusableView.reuseIdentifier)
        collectionView.contentInset.bottom = CollectionReusableView.size.height
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = Color(.Gainsboro)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // MARK: - LinearRefresher
        linearRefresher.addTarget(self, action: #selector(loadData(_:)), for: .valueChanged)
        collectionView.addSubview(linearRefresher)
        
        // Load the data
        loadData(self)
    }
    
    // MARK: - UITraitCollection
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Only execute the following codeblock if the user interface style changes
        guard traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle else {
            return
        }
        
        // Set the views' background colors
        navigationController?.view.backgroundColor = Color(.White)
        view.backgroundColor = Color(.White)
        collectionView.backgroundColor = Color(.Gainsboro)
        
        // Reset the navigation bar
        navigationController?.navigationBar.barTintColor = Color(.White)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Color(.Accent), .font: Font.with(.black, .body)]
    }
    
    @objc fileprivate func leaveViewController(_ sender: Any) {
        // MARK: - NavigationTransitionController
        self.navigationTransitionController?.dismissNavigation()
    }

    /// Load all of the schools
    /// - Parameter sender: Any object that calls this method
    @objc fileprivate func loadData(_ sender: Any) {
        // Update the Boolean
        self.isLoadingData = true
        
        // MARK: - LinearRefresher
        self.linearRefresher.animate(true)
        
        // MARK: - Service
        Service.shared.fetchSchoolSATDetails(school: self.school) { (schoolSATDetails: [SchoolSATDetail]?, error: Error?) in
            if error == nil {
                // Update the data source
                self.schoolSATDetails = schoolSATDetails ?? []
                
                // Update the Boolean
                self.isLoadingData = false
                
                // Update the pagination values
                self.offset = self.schoolSATDetails.count

                // Execute after all requests were made
                DispatchQueue.main.async {
                    // MARK: - LinearRefresher
                    self.linearRefresher.animate(false)
                    // Reload the collection view data
                    self.collectionView.reloadData()
                }
                
            } else {
                print("\(self.classForCoder)/\(#line) - Error: \(error?.localizedDescription as Any)")
                // Update the Boolean
                self.isLoadingData = false

                // Execute after all requests were made
                DispatchQueue.main.async {
                    // MARK: - LinearRefresher
                    self.linearRefresher.animate(false)
                    // Reload the collection view data
                    self.collectionView.reloadData()
                }
            }
        }
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension SchoolSATDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return schoolSections.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch schoolSections[section] {
        case .school:
            return 1
        case .details:
            return schoolSATDetails.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Return the approiate cell size
        switch schoolSections[indexPath.section] {
        case .school:
            return SchoolSATDetailCell.size
        case .details:
            return SchoolSATDetailCell.size
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Return the approiate header size
        switch schoolSections[section] {
        case .school:
            return CollectionReusableView.size
        case .details:
            return CollectionReusableView.size
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // Only return the footer for the last section and if the details exist
        return section == collectionView.lastSection && !schoolSATDetails.isEmpty ? CollectionReusableView.size : CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // Get the section title
        let title = schoolSections[indexPath.section].rawValue
        
        // MARK: - collectionReusableView
        let collectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionReusableView.reuseIdentifier, for: indexPath) as! CollectionReusableView
        // Display the title for the header since there'll always be school data
        if kind == UICollectionView.elementKindSectionHeader,
           schoolSections[indexPath.section] == .school {
            collectionReusableView.updateContent(labelAttributedString: NSAttributedString(string: title, attributes: [.foregroundColor: Color(.Black), .font: Font.with(.bold, .body)]))
        } else if kind == UICollectionView.elementKindSectionHeader,
                  schoolSections[indexPath.section] == .details {
            // Determine if there's no school data
            let isDetailsNonExistant: Bool = schoolSATDetails.isEmpty
            // If there aren't any school details, we need to change the title
            collectionReusableView.updateContent(labelAttributedString: NSAttributedString(string: isDetailsNonExistant ? "SAT Details Not Available..." : title, attributes: [.foregroundColor: Color(.LightGray), .font: Font.with(.bold, .body)]), textAlignment: isDetailsNonExistant ? .center : .left)
        }
        return collectionReusableView
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch SchoolSection.allCases[indexPath.section] {
        case .school:
            // MARK: - SchoolCell
            let schoolCell = collectionView.dequeueReusableCell(withReuseIdentifier: SchoolCell.reuseIdentifier, for: indexPath) as! SchoolCell
            schoolCell.updateContent(school: school, shouldTruncateText: false, delegate: self)
            return schoolCell
        case .details:
            // MARK: - SchoolSATDetailCell
            let schoolSATDetailCell = collectionView.dequeueReusableCell(withReuseIdentifier: SchoolSATDetailCell.reuseIdentifier, for: indexPath) as! SchoolSATDetailCell
            schoolSATDetailCell.updateContent(schoolSATDetail: schoolSATDetails[indexPath.item])
            return schoolSATDetailCell
        }
    }
}



// MARK: - SchoolCellDelegate
extension SchoolSATDetailViewController: SchoolCellDelegate {
    func schoolCellFavoritedSchool(_ school: School?) {
        // Call this class' delegate so the SchoolViewController class knows we've updated its favorite state
        self.delegate?.schoolSATDetailViewControllerFavoriteChanged(school)
    }
}
