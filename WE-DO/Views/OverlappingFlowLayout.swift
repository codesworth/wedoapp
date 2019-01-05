//
//  OverlappingFlowLayout.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 26/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import UIKit

class OverlappingFlowLayout: UICollectionViewFlowLayout {
    
    var overlap: CGFloat!
    
    convenience init(overlap:CGFloat = 30) {
        self.init()
        self.overlap = overlap
    }
    
    override init() {
        super.init()
        self.scrollDirection = .horizontal
        self.minimumInteritemSpacing = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize{
        let xSize = CGFloat(self.collectionView!.numberOfItems(inSection: 0)) * self.itemSize.width
        let ySize = CGFloat(self.collectionView!.numberOfSections) * self.itemSize.height
        
        var contentSize = CGSize(width: xSize, height: ySize)
        
        if self.collectionView!.bounds.size.width > contentSize.width {
            contentSize.width = self.collectionView!.bounds.size.width
        }
        
        if self.collectionView!.bounds.size.height > contentSize.height {
            contentSize.height = self.collectionView!.bounds.size.height
        }
        
        return contentSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributesArray = super.layoutAttributesForElements(in: rect)
        let numberOfItems = self.collectionView!.numberOfItems(inSection: 0)
        
        for attributes in attributesArray! {
            var xPosition = attributes.center.x
            let yPosition = attributes.center.y
            
            if attributes.indexPath.row == 0 {
                attributes.zIndex = Int(INT_MAX) // Put the first cell on top of the stack
            } else {
                xPosition -= self.overlap * CGFloat(attributes.indexPath.row)
                attributes.zIndex = numberOfItems - attributes.indexPath.row //Other cells below the first one
            }
            
            attributes.center = CGPoint(x: xPosition, y: yPosition)
        }
        
        return attributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return UICollectionViewLayoutAttributes(forCellWith: indexPath)
    }
    
}



