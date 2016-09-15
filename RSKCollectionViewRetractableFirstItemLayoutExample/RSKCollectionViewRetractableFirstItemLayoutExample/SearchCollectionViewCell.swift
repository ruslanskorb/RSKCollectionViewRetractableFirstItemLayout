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

internal final class SearchCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Internal Properties
    
    internal var searchBar: UISearchBar!
    
    // MARK: - Object Lifecycle
    
    internal override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.searchBar = UISearchBar()
        
        self.contentView.addSubview(self.searchBar)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    internal override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.searchBar.frame = CGRect(origin: CGPoint.zero, size: self.contentView.bounds.size)
    }
    
    internal override class var requiresConstraintBasedLayout: Bool {
        
        return false
    }
}
