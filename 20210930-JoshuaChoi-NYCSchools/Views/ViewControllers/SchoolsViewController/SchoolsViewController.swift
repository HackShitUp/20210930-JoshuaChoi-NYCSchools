//
//  SchoolsViewController.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit
import NavigationTransitionController



/**
 Abstract: View Controller class that displays a list of NYC schools
 */
class SchoolsViewController: UIViewController {
    

    // MARK: - Class Vars
    
    // MARK: - School
    var schools: [School] = []
    
    // MARK: - LinearRefresher
    let linearRefresher: LinearRefresher = LinearRefresher()
    
    // MARK: - UICollectionView
    let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    
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
        self.limit = 20
        
        // Setup the navigation bar
        navigationItem.title = "NYC Schools 🎓"
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
        collectionView.register(CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionReusableView.reuseIdentifier)
        collectionView.contentInset.bottom = CollectionReusableView.size.height
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = Color(.Gainsboro)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // MARK: - LinearRefresher
        linearRefresher.addTarget(self, action: #selector(loadInitialData(_:)), for: .valueChanged)
        collectionView.addSubview(linearRefresher)
        
        // Load the data
        loadInitialData(self)
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
    
    /// Load all of the schools
    /// - Parameter sender: Any object that calls this method
    @objc func loadInitialData(_ sender: Any) {
        // Update the Boolean
        self.isLoadingData = true
        
        // MARK: - LinearRefresher
        self.linearRefresher.animate(true)
        
        // Reset the offset
        self.offset = 0
        
        // MARK: - Service
        Service.shared.fetchSchools(offset: self.offset, limit: self.limit) { (schools: [School]?, error: Error?) in
            if error == nil {
                // Update the Boolean
                self.isLoadingData = false
                
                // Update the data source
                self.schools = schools ?? []
                
                // Update the offset value
                self.offset = self.schools.count
                
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
    
    /// Load more data when we've reached the end of the result
    /// - Parameter scrollView: A UIScrollView object that calls this method
    @objc func loadMoreDataIfNecessary(_ scrollView: UIScrollView) {
        // Ensure the scroll view reached the end, its scroll is ending, and that it's not loading data
        guard scrollView.isAtEndOfScroll && !isLoadingData else {
            return
        }
        
        // MARK: - CollectionReusableView
        guard let collectionReusableView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: self.collectionView.lastSection)) as? CollectionReusableView else {
            return
        }
        collectionReusableView.animate(true)
        
        // MARK: - Service
        // Get more schools
        Service.shared.fetchSchools(offset: self.offset, limit: self.limit) { (objects: [School]?, error: Error?) in
            if error == nil {
                // Update the Boolean
                self.isLoadingData = false
                
                // Stop the animation
                collectionReusableView.animate(true)
                
                // Ensure the list of (1) original objects (before the requests) and (2) new objects (after the request) aren't empty
                guard !self.schools.isEmpty, let objects = objects, !objects.isEmpty else {
                    return
                }
                
                // Map the objects to their index paths
                let indexPaths = objects.enumerated().map { (i: Int, school: School) -> IndexPath in
                    return IndexPath(item: self.schools.count + i, section: self.collectionView.lastSection)
                }

                // Execute the following codeblock without animations in the main thread
                DispatchQueue.main.async {
                    CATransaction.begin()
                    CATransaction.setDisableActions(true)
                    self.collectionView.performBatchUpdates {
                        // Update the data source
                        self.schools.append(contentsOf: objects)
                        // Update the pagination
                        self.offset += objects.count
                        // Insert the items in the collection view
                        self.collectionView.insertItems(at: indexPaths)
                    } completion: { (finished: Bool) in
                        CATransaction.commit()
                    }
                }
                
            } else {
                print("\(self.classForCoder)/\(#line) - Error: \(error?.localizedDescription as Any)")
                // Update the Boolean
                self.isLoadingData = false
                // Stop the animation
                collectionReusableView.animate(true)
            }
        }
    }
}
