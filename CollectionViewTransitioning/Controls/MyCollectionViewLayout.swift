//
//  MyLayout.swift
//  CollectionViewTransitioning
//
//  Created by Nattapong Unaregul on 4/4/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//
//
//  Created by Nattapong Unaregul on 4/4/2558 BE.
//  Copyright (c) 2558 Nattapong. All rights reserved.
//

import UIKit
@objc protocol UICollectionViewDelegateTJProductLayout : UICollectionViewDelegate{
    func maximumNumberOfColumnsForCollectionView(collectionView : UICollectionView ,layout : UICollectionViewLayout) -> UInt8
}
enum LayoutCollectionView : Int{
    case oneColumn = 1 , twoColumn = 2,rowRecords = 3
}
class MyCollectionViewLayout : UICollectionViewLayout{
    
    //Containers for keeping track of changing items
    private var layoutCellAttributes = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
    private var layoutSupplementaryAttributesByKind = Dictionary<String, Dictionary<IndexPath,UICollectionViewLayoutAttributes>>()
    private var removedIndexPaths : NSMutableArray?
    private var removedSections : NSMutableArray?
    
    private var spacingTopFloatingInset = 0 as CGFloat
    private var horizontalInset = 8 as CGFloat
    private var verticalInset = 8 as CGFloat
    
    private var itemHeight = 0.0 as CGFloat
    private var itemWidth = 0.0 as CGFloat
    
    private var contentSize = CGSize.zero
    private var column = 2 as UInt8
    private var layout : LayoutCollectionView = .twoColumn
    //Loding View
    private var showLoading : Bool = false
    let LoadingViewSize = CGSize(width: UIScreen.main.bounds.width, height: 35)
    
    var cellHeight : CGFloat {
        get {
            return itemHeight
        }
    }
    var cellWidth : CGFloat {
        get {
            return itemWidth
        }
    }
    
    override init() {
        super.init()
    }
    init(withLayout:LayoutCollectionView) {
        super.init()
        layout = withLayout
        if withLayout == .oneColumn || withLayout == .rowRecords{
            column = 1
            
        }else {
            column = 2
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func CalculateCellsize(NumberofColumns:UInt8,iwidth :inout CGFloat,  iheight :inout CGFloat){
        
        let NumberOfCoumnCGFLoat : CGFloat = CGFloat(NumberofColumns)
        let RemainningWidth = self.collectionView!.frame.width - (horizontalInset * (NumberOfCoumnCGFLoat)) as CGFloat
        switch (layout){
        case .oneColumn :
            if UIScreen.main.bounds.height == 568 { //Iphone 5
                iwidth = RemainningWidth - horizontalInset
                iheight = 405
            }else if UIScreen.main.bounds.height == 736 { //Iphone 6s
                iwidth = RemainningWidth - horizontalInset
                iheight = 500
            }else if UIScreen.main.bounds.height == 320 {//iphone 4gs
                iwidth = RemainningWidth - horizontalInset
                iheight = 430
                
            }else{ //Iphone 6
                iwidth = RemainningWidth - horizontalInset
                iheight = iwidth * 1.30
            }
        case .rowRecords :
            iwidth = RemainningWidth
            iheight = 150
        default : //2
            if UIScreen.main.bounds.height == 568 { //Iphone 5
                iwidth = RemainningWidth / NumberOfCoumnCGFLoat - horizontalInset/2
                iheight = 238
            }else if UIScreen.main.bounds.height == 736 { //Iphone 6 plus
                iwidth = RemainningWidth / NumberOfCoumnCGFLoat - horizontalInset/2
                iheight = 285
            }else if UIScreen.main.bounds.height == 320 {//iphone 4gs
                iwidth = RemainningWidth / NumberOfCoumnCGFLoat - horizontalInset/2
                iheight = 238
                
            }else{ //Iphone 6
                iwidth = RemainningWidth / NumberOfCoumnCGFLoat - horizontalInset/2
                iheight = iwidth * 1.52
            }
            
        }
    }
    func calculateLayout(NumberofColumns:UInt8 ){
        var LayoutSupplementaryHeaderDictionary  = Dictionary<IndexPath,UICollectionViewLayoutAttributes>()
        if layout == .oneColumn || layout == .twoColumn {
            
        }else{
            horizontalInset = 0
            verticalInset = 3 as CGFloat
        }
        CalculateCellsize( NumberofColumns: NumberofColumns, iwidth: &self.itemWidth, iheight: &self.itemHeight)
        let headerHeight = CGFloat(spacingTopFloatingInset)
        // 2
        let numberOfSections = self.collectionView!.numberOfSections
        var yOffset = verticalInset
        
        for section in 0...numberOfSections - 1 {
            let path = IndexPath(item: 0, section: section)
            let attributesHeader = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: path)
            attributesHeader.frame = CGRect(x:0, y:0,width: self.collectionView!.frame.size.width,height:headerHeight)
            LayoutSupplementaryHeaderDictionary[path] = attributesHeader
            let numberOfItems = self.collectionView!.numberOfItems(inSection: section)
            var xOffset = horizontalInset
            for item in 0...numberOfItems - 1 {
                let ItemindexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: ItemindexPath)
                var itemSize = CGSize.zero
                itemSize.width = itemWidth
                itemSize.height = itemHeight
                var increaseRow = false
                attributes.center = CGPoint(x:xOffset + (itemWidth / 2), y:yOffset + (itemHeight / 2))
                attributes.size = CGSize(width:itemWidth, height:itemHeight)
                self.layoutCellAttributes[ItemindexPath] = attributes // 7
                xOffset += itemSize.width
                if(xOffset + self.horizontalInset >= self.collectionView!.frame.width - (self.collectionView!.contentInset.right * 2)){
                    increaseRow = true
                }
                xOffset += self.horizontalInset
                if increaseRow && !(item == numberOfItems - 1 && section == numberOfSections - 1) {
                    yOffset += self.verticalInset
                    yOffset += self.itemHeight
                    xOffset = horizontalInset
                }
            }
        }
        
        
        self.layoutSupplementaryAttributesByKind[UICollectionElementKindSectionHeader] = LayoutSupplementaryHeaderDictionary
        yOffset += self.itemHeight
        
        if self.showLoading {
            yOffset += self.LoadingViewSize.height
        }
        
        contentSize = CGSize(width:self.collectionView!.frame.size.width - horizontalInset
            ,height:yOffset + verticalInset) // 11
    }
    override func prepare() {
        layoutCellAttributes.removeAll(keepingCapacity: true)
        layoutSupplementaryAttributesByKind.removeAll(keepingCapacity: true)
        calculateLayout(NumberofColumns: column)
    }
    
    
    func layoutKeyForIndexPath(indexPath : NSIndexPath) -> String {
        return "\(indexPath.section)\(indexPath.row)"
    }
    
    func layoutKeyForHeaderAtIndexPath(indexPath : NSIndexPath) -> String {
        return "s\(indexPath.section)\(indexPath.row)"
    }
    
    // MARK: -
    // MARK: Invalidate
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        let oldBounds : CGRect = self.collectionView!.bounds
//        if oldBounds.equalTo(newBounds){
//            return true
//        }
//        return false
//    }
    // MARK: -
    // MARK: Required methods
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    
//    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        var AnAttribute  : UICollectionViewLayoutAttributes?
//        if elementKind == UICollectionElementKindSectionHeader {
//            AnAttribute = self.layoutSupplementaryAttributesByKind[elementKind]?[indexPath]
//        }else{
//            AnAttribute = self.layoutSupplementaryAttributesByKind[elementKind]?[indexPath]
//        }
//        return AnAttribute
//    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutCellAttributes[indexPath]
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var AttibutesArray : [UICollectionViewLayoutAttributes] = []
        for (_ ,value) in layoutCellAttributes{
            if rect.intersects(value.frame) {
                AttibutesArray.append(value)
            }
            
            
        }
//        for(key,value) in layoutSupplementaryAttributesByKind{
//            
//            if key == UICollectionElementKindSectionHeader {
//                for(_ ,value) in value{
//                    if rect.intersects(value.frame){
//                        AttibutesArray.append(value)
//                    }
//                }
//            }
//        }
        
        return AttibutesArray
    }
    override func finalizeAnimatedBoundsChange() {
        super.finalizeAnimatedBoundsChange()
    }
    override func prepareForTransition(to newLayout: UICollectionViewLayout) {
        let lastestLayout = (newLayout as! MyCollectionViewLayout).layout
        CurrentLayout.sharedInstance.layout = lastestLayout
    }


    
}
