//
//  BaconCardCollectionViewCell.swift
//  Bacon
//
//  Created by Nattapong Unaregul on 3/18/2560 BE.
//  Copyright © 2560 Nattapong Unaregul. All rights reserved.
//



import UIKit;
class CurrentLayout : NSObject {
    var layout :LayoutCollectionView
    private override init() {
        layout = LayoutCollectionView.rowRecords
        super.init()
    }
    static let sharedInstance : CurrentLayout = CurrentLayout()
}
class MyCell: UICollectionViewCell {
    var indexPath : NSIndexPath?
    var thumbnail: UIImageView!
    var title: UILabel!
    var layout : LayoutCollectionView!
    let marginOffset : CGFloat = 10
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        self.layoutIfNeeded()
        self.setLayoutAccordingToDesiredLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.contentView.clipsToBounds = true
        thumbnail = UIImageView()
        title = UILabel()
        thumbnail.clipsToBounds = true
        //The subviews under this view are allowed to shrink, expand appropiately otherwise reused cells(dequeueReusableCell) can not transform its frame to another
        self.contentView.autoresizingMask = [.flexibleWidth ,.flexibleHeight]
        self.contentView.addSubview(thumbnail)
        self.contentView.addSubview(title)
        setLayoutAccordingToDesiredLayout()
    }
    func setLayoutAccordingToDesiredLayout(){
        layout = CurrentLayout.sharedInstance.layout
        if CurrentLayout.sharedInstance.layout == LayoutCollectionView.oneColumn
            || CurrentLayout.sharedInstance.layout == LayoutCollectionView.twoColumn {
            DoColumnLayout(desiredLayout: CurrentLayout.sharedInstance.layout)
        }else{
            DoRecordLayout()
        }
    }
    func DoRecordLayout(){
        let cf = self.contentView.frame
        thumbnail.frame = CGRect(x: 0, y: 0, width: cf.height, height: cf.height)
        title.frame = CGRect(x: cf.height + marginOffset, y: marginOffset, width: cf.width - marginOffset * 2 , height: 30)
    }
    func DoColumnLayout(desiredLayout : LayoutCollectionView){
        let cf = self.contentView.frame
        thumbnail.frame = CGRect(x: 0, y: 0, width: cf.width, height: cf.width)
        title.frame = CGRect(x: marginOffset, y: cf.width + marginOffset , width: cf.width - marginOffset * 2 , height: 30)
    }
    override func prepareForReuse() {
        self.thumbnail.image = nil
        super.prepareForReuse()
    }
}
