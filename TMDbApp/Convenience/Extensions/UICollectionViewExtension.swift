//
//  UICollectionViewExtension.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 28/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    var centerCellIndexPath: IndexPath? {
        
        if visibleCells.count == 0 {
            return nil
        }
        
        var closestCellFromCenter = visibleCells[0]
        for cell in visibleCells {
            let closestCellDelta = fabs(closestCellFromCenter.center.x - self.bounds.size.width/2 - self.contentOffset.x)
            let cellDelta = fabs(cell.center.x - self.bounds.size.width/2 - self.contentOffset.x)
            if cellDelta < closestCellDelta {
                closestCellFromCenter = cell
            }
        }
        
        return indexPath(for: closestCellFromCenter)
    }
    
    var scrollDidReachRightEdge: Bool {
        return self.contentOffset.x >= (self.contentSize.width - self.frame.size.width)
    }
    
}
