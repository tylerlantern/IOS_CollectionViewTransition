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
    var Thumbnail: UIImageView!
    var layout : LayoutCollectionView!
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
                self.layoutIfNeeded()
        self.SetLayoutAccordingToDesiredLayout()

        
    }
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.contentView.clipsToBounds = true
        Thumbnail = UIImageView()
        Thumbnail.clipsToBounds = true
        self.contentView.addSubview(Thumbnail)
        SetLayoutAccordingToDesiredLayout()
        
    }
    func SetLayoutAccordingToDesiredLayout(){
        layout = CurrentLayout.sharedInstance.layout
        if CurrentLayout.sharedInstance.layout == LayoutCollectionView.oneColumn
            || CurrentLayout.sharedInstance.layout == LayoutCollectionView.twoColumn {
            DoColumnLayout(DesiredLayout: CurrentLayout.sharedInstance.layout)
        }else{
            DoRecordLayout()
        }
    }
    
    func DoRecordLayout(){
        let cf = self.contentView.frame
        Thumbnail.frame = CGRect(x: 0, y: 0, width: cf.height, height: cf.height)
    }
    func DoColumnLayout(DesiredLayout : LayoutCollectionView){
        let cf = self.contentView.frame
        Thumbnail.frame = CGRect(x: 0, y: 0, width: cf.width, height: cf.width)
    }
    override func prepareForReuse() {
        self.Thumbnail.image = nil
        super.prepareForReuse()
    }
}
