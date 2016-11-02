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

/// A light-weight `UICollectionViewFlowLayout` subclass that allows the first item to be retractable.
open class RSKCollectionViewRetractableFirstItemLayout: UICollectionViewFlowLayout {
    
    // MARK: - Private Properties
    
    fileprivate let firstItemIndexPath = IndexPath(item: 0, section: 0)
    
    fileprivate var lastKnownTargetContentOffset: CGPoint?
    
    // MARK: - Public Properties
    
    /// The inset of the first item's retractable area within the first item's content area. Default value is `UIEdgeInsetsZero`.
    open var firstItemRetractableAreaInset = UIEdgeInsets.zero
    
    /// A Boolean value that determines whether the retractability of the first item is enabled. Default value is `true`.
    open var isEnabledRetractabilityOfFirstItem = true
    
    // MARK: - Superclass Properties
    
    open override var scrollDirection: UICollectionViewScrollDirection {
        
        didSet {
            
            if self.scrollDirection != oldValue {
                
                self.lastKnownTargetContentOffset = nil
            }
        }
    }
    
    // MARK: - Superclass Methods
    
    open override var collectionViewContentSize: CGSize {
        
        guard self.isEnabledRetractabilityOfFirstItem else {
            
            return super.collectionViewContentSize
        }
        
        guard let collectionView = self.collectionView, let _ = collectionView.delegate as? UICollectionViewDelegateFlowLayout, let firstItemLayoutAttributes = self.layoutAttributesForItem(at: self.firstItemIndexPath) else {
            
            return super.collectionViewContentSize
        }
        
        var collectionViewContentSize = super.collectionViewContentSize
        
        switch self.scrollDirection {
            
        case .vertical:
            collectionViewContentSize.height = max(collectionViewContentSize.height, collectionView.frame.height + firstItemLayoutAttributes.frame.height)
            return collectionViewContentSize
            
        case .horizontal:
            collectionViewContentSize.width = max(collectionViewContentSize.width, collectionView.frame.width + firstItemLayoutAttributes.frame.width)
            return collectionViewContentSize
        }
    }
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard self.isEnabledRetractabilityOfFirstItem else {
            
            let targetContentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            self.lastKnownTargetContentOffset = targetContentOffset
            
            return targetContentOffset
        }
        
        guard let _ = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout, let firstItemLayoutAttributes = self.layoutAttributesForItem(at: self.firstItemIndexPath) else {
            
            let targetContentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            self.lastKnownTargetContentOffset = targetContentOffset
            
            return targetContentOffset
        }
        
        let firstItemFrame = firstItemLayoutAttributes.frame
        
        let lastKnownTargetContentOffsetY: CGFloat?
        let proposedContentOffsetX: CGFloat
        let proposedContentOffsetY: CGFloat
        let firstItemRetractableAreaInsetTop: CGFloat
        let firstItemRetractableAreaInsetBottom: CGFloat
        let firstItemFrameMinY: CGFloat
        let firstItemFrameMidY: CGFloat
        let firstItemFrameMaxY: CGFloat
        
        switch self.scrollDirection {
            
        case .vertical:
            lastKnownTargetContentOffsetY = self.lastKnownTargetContentOffset?.y
            proposedContentOffsetX = proposedContentOffset.x
            proposedContentOffsetY = proposedContentOffset.y
            firstItemRetractableAreaInsetTop = self.firstItemRetractableAreaInset.top
            firstItemRetractableAreaInsetBottom = self.firstItemRetractableAreaInset.bottom
            firstItemFrameMinY = firstItemFrame.minY
            firstItemFrameMidY = firstItemFrame.midY
            firstItemFrameMaxY = firstItemFrame.maxY
            
        case .horizontal:
            lastKnownTargetContentOffsetY = self.lastKnownTargetContentOffset?.x
            proposedContentOffsetX = proposedContentOffset.y
            proposedContentOffsetY = proposedContentOffset.x
            firstItemRetractableAreaInsetTop = self.firstItemRetractableAreaInset.left
            firstItemRetractableAreaInsetBottom = self.firstItemRetractableAreaInset.right
            firstItemFrameMinY = firstItemFrame.minX
            firstItemFrameMidY = firstItemFrame.midX
            firstItemFrameMaxY = firstItemFrame.maxX
        }
        
        guard proposedContentOffsetY > firstItemFrameMinY && proposedContentOffsetY < firstItemFrameMaxY else {
            
            let targetContentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
            self.lastKnownTargetContentOffset = targetContentOffset
            
            return targetContentOffset
        }
        
        var targetContentOffset: CGPoint
        if let lastKnownTargetContentOffsetY = lastKnownTargetContentOffsetY {
            
            if lastKnownTargetContentOffsetY > proposedContentOffsetY {
                
                if proposedContentOffsetY > firstItemFrameMaxY - firstItemRetractableAreaInsetBottom {
                    
                    targetContentOffset = CGPoint(x: proposedContentOffsetX, y: firstItemFrameMaxY)
                }
                else {
                    
                    targetContentOffset = CGPoint(x: proposedContentOffsetX, y: firstItemFrameMinY)
                }
            }
            else {
                
                if proposedContentOffsetY < firstItemRetractableAreaInsetTop {
                    
                    targetContentOffset = CGPoint(x: proposedContentOffsetX, y: firstItemFrameMinY)
                }
                else {
                    
                    targetContentOffset = CGPoint(x: proposedContentOffsetX, y: firstItemFrameMaxY)
                }
            }
        }
        else {
            
            if velocity.y > 0.0 {
                
                targetContentOffset = CGPoint(x: proposedContentOffsetX, y: firstItemFrameMaxY)
            }
            else if velocity.y < 0.0 {
                
                targetContentOffset = CGPoint(x: proposedContentOffsetX, y: firstItemFrameMinY)
            }
            else {
                
                if proposedContentOffsetY > firstItemFrameMidY {
                    
                    targetContentOffset = CGPoint(x: proposedContentOffsetX, y: firstItemFrameMaxY)
                }
                else {
                    
                    targetContentOffset = CGPoint(x: proposedContentOffsetX, y: firstItemFrameMinY)
                }
            }
        }
        
        switch self.scrollDirection {
            
        case .horizontal:
            targetContentOffset = CGPoint(x: targetContentOffset.y, y: targetContentOffset.x)
            
        default:
            break
        }
        
        self.lastKnownTargetContentOffset = targetContentOffset
        
        return targetContentOffset
    }
}
