//
//  SchoolsViewController+Delegate.swift
//  20210930-JoshuaChoi-NYCSchools
//
//  Created by Joshua Choi on 9/29/21.
//

import UIKit
import DZNEmptyDataSet
import NavigationTransitionController



// MARK: - DZNEmptyDataSetSource/DZNEmptyDataSetDelegate
extension SchoolsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func emptyDataSetShouldBeForced(toDisplay scrollView: UIScrollView!) -> Bool {
        return schools.isEmpty
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No Results", attributes: [.foregroundColor: Color(.LightGray), .font: Font.with(.bold, .heading)])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Something went wrong. Please try again.", attributes: [.foregroundColor: Color(.LightGray), .font: Font.with(.bold, .body)])
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        return NSAttributedString(string: "Try Again", attributes: [.foregroundColor: Color(.Accent), .font: Font.with(.black, .heading)])
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        // Reload the initial data
        self.loadInitialData(self)
    }
}




// MARK: - UIScrollViewDelegate
extension SchoolsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadMoreDataIfNecessary(scrollView)
    }
}



// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension SchoolsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return SchoolCell.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CollectionReusableView.size
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // MARK: - collectionReusableView
        let collectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionReusableView.reuseIdentifier, for: indexPath) as! CollectionReusableView
        return collectionReusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // MARK: - SchoolCell
        let schoolCell = collectionView.dequeueReusableCell(withReuseIdentifier: SchoolCell.reuseIdentifier, for: indexPath) as! SchoolCell
        schoolCell.updateContent(school: schools[indexPath.item])
        return schoolCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Ensure the index isn't out of bounds
        guard schools.indices.contains(indexPath.item) else {
            return
        }
        
        // MARK: - SchoolSATDetailViewController
        let schoolSATDetailVC = SchoolSATDetailViewController(school: schools[indexPath.item], delegate: self)
        // MARK: - NavigationTransitionController
        // Made by yours truly — this library enables an easy way to perform view controller transition animations while persisting the navigation bar with 4 different types of built-in transitions (https://github.com/nanolens/NavigationTransitionController)
        let navigationTransitionController = NavigationTransitionController(rootViewController: schoolSATDetailVC)
        navigationTransitionController.presentNavigation(self)
    }
}



// MARK: - SchoolSATDetailViewControllerDelegate
extension SchoolsViewController: SchoolSATDetailViewControllerDelegate {
    func schoolSATDetailViewControllerFavoriteChanged(_ school: School?) {
        // Get the associated index of the school that updated its favorite state and update the data source/cell with the new School object
        if let school = school,
           let i = self.schools.firstIndex(where: {$0.id == school.id}),
           let schoolCell = self.collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? SchoolCell {
            // Update the data source
            self.schools[i] = school
            schoolCell.updateContent(school: school)
            
            // Reload the collection view at the specified index path
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.collectionView.reloadItems(at: [IndexPath(item: i, section: 0)])
            CATransaction.commit()
        }
    }
}
