//
// Copyright 2016-present Ruslan Skorb, http://ruslanskorb.com/
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this work except in compliance with the License.
// You may obtain a copy of the License in the LICENSE file, or at:
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit

internal final class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let colors = [
        "Emma":     UIColor(red: 81     / 255.0,    green: 81      / 255.0,     blue: 79       / 255.0,     alpha: 1.0),
        "Oliver":   UIColor(red: 242    / 255.0,    green: 94      / 255.0,     blue: 92       / 255.0,     alpha: 1.0),
        "Jack":     UIColor(red: 242    / 255.0,    green: 167     / 255.0,     blue: 92       / 255.0,     alpha: 1.0),
        "Olivia":   UIColor(red: 229    / 255.0,    green: 201     / 255.0,     blue: 91       / 255.0,     alpha: 1.0),
        "Harry":    UIColor(red: 35     / 255.0,    green: 123     / 255.0,     blue: 160      / 255.0,     alpha: 1.0),
        "Sophia":   UIColor(red: 112    / 255.0,    green: 193     / 255.0,     blue: 178      / 255.0,     alpha: 1.0)
    ]
    
    private var filteredNames: [String]!
    
    private let names = ["Emma", "Oliver", "Jack", "Olivia", "Harry", "Sophia"]
    
    private var readyForPresentation = false
    
    // MARK: - Object Lifecycle
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.filteredNames = self.names
        
        self.collectionView.registerClass(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell.identifier")
        self.collectionView.registerClass(TextCollectionViewCell.self, forCellWithReuseIdentifier: "TextCollectionViewCell.identifier")
        
        if let collectionViewLayout = self.collectionView.collectionViewLayout as? RSKCollectionViewRetractableFirstItemLayout {
            
            collectionViewLayout.firstItemRetractableAreaInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
        }
    }
    
    // MARK: - Layout
    
    internal override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        guard self.readyForPresentation == false else {
            
            return
        }
        
        self.readyForPresentation = true
        
        let searchItemIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        self.collectionView.contentOffset = CGPoint(x: 0.0, y: self.collectionView(self.collectionView, layout: self.collectionView.collectionViewLayout, sizeForItemAtIndexPath: searchItemIndexPath).height)
    }
    
    // MARK: - UICollectionViewDataSource
    
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SearchCollectionViewCell.identifier", forIndexPath: indexPath) as! SearchCollectionViewCell
            
            cell.searchBar.delegate = self
            cell.searchBar.searchBarStyle = .Minimal
            cell.searchBar.placeholder = "Search - \(self.names.count) names"
            
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TextCollectionViewCell.identifier", forIndexPath: indexPath) as! TextCollectionViewCell
            
            let name = self.filteredNames[indexPath.item]
            
            cell.colorView.layer.cornerRadius = 10.0
            cell.colorView.layer.masksToBounds = true
            cell.colorView.backgroundColor = self.colors[name]
            
            cell.label.textColor = UIColor.whiteColor()
            cell.label.textAlignment = .Center
            cell.label.text = name
            
            return cell
            
        default:
            assert(false)
        }
    }
    
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            return 1
            
        case 1:
            return self.filteredNames.count
            
        default:
            assert(false)
        }
    }
    
    internal func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 2
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        switch section {
            
        case 0:
            return UIEdgeInsetsZero
            
        case 1:
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
            
        default:
            assert(false)
        }
    }
    
    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 10.0
    }
    
    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 10.0
    }
    
    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch indexPath.section {
            
        case 0:
            let itemWidth = collectionView.frame.width
            let itemHeight: CGFloat = 44.0
            
            return CGSize(width: itemWidth, height: itemHeight)
        
        case 1:
            let numberOfItemsInLine: CGFloat = 3
            
            let inset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAtIndex: indexPath.section)
            let minimumInteritemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAtIndex: indexPath.section)
            
            let itemWidth = (collectionView.frame.width - inset.left - inset.right - minimumInteritemSpacing * (numberOfItemsInLine - 1)) / numberOfItemsInLine
            let itemHeight = itemWidth
            
            return CGSize(width: itemWidth, height: itemHeight)
            
        default:
            assert(false)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    internal func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        guard scrollView === self.collectionView else {
            
            return
        }
        
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        guard let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as? SearchCollectionViewCell else {
            
            return
        }
        
        guard cell.searchBar.isFirstResponder() else {
            
            return
        }
        
        cell.searchBar.resignFirstResponder()
    }
    
    // MARK: - UISearchBarDelegate
    
    internal func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let oldFilteredNames = self.filteredNames!
        
        if searchText.isEmpty {
            
            self.filteredNames = self.names
        }
        else {
            
            self.filteredNames = self.names.filter({ (name) -> Bool in
                
                return name.hasPrefix(searchText)
            })
        }
        
        self.collectionView.performBatchUpdates({
            
            for (oldIndex, oldName) in oldFilteredNames.enumerate() {
                
                if self.filteredNames.contains(oldName) == false {
                    
                    let indexPath = NSIndexPath(forItem: oldIndex, inSection: 1)
                    self.collectionView.deleteItemsAtIndexPaths([indexPath])
                }
            }
            
            for (index, name) in self.filteredNames.enumerate() {
                
                if oldFilteredNames.contains(name) == false {
                    
                    let indexPath = NSIndexPath(forItem: index, inSection: 1)
                    self.collectionView.insertItemsAtIndexPaths([indexPath])
                }
            }
            
        }, completion: nil)
    }
}
