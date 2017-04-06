//
//  ViewController.swift
//  CollectionViewTransitioning
//
//  Created by Nattapong Unaregul on 4/4/17.
//  Copyright © 2017 Nattapong Unaregul. All rights reserved.
//

import UIKit


class MyCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    //    var currentLayout : LayoutCollectionView = .RowRecords
    
    @IBOutlet weak var collectionView: UICollectionView!
    let oneColumnLayout : MyCollectionViewLayout = MyCollectionViewLayout(withLayout: LayoutCollectionView.oneColumn)
    let twoColumnLayout : MyCollectionViewLayout = MyCollectionViewLayout(withLayout: LayoutCollectionView.twoColumn)
    let recordsLayout : MyCollectionViewLayout = MyCollectionViewLayout(withLayout: LayoutCollectionView.rowRecords)
    let reusedCollectionViewCellIdentiier = "myCollectionViewIdentifier"
    
    @IBAction func toggleLayout(_ sender: Any) {
        if CurrentLayout.sharedInstance.layout == LayoutCollectionView.twoColumn {
            self.collectionView.setCollectionViewLayout(oneColumnLayout, animated: true)
        }
        else if CurrentLayout.sharedInstance.layout == LayoutCollectionView.oneColumn{
            self.collectionView.setCollectionViewLayout(recordsLayout, animated: true)
        }
        else{
            self.collectionView.setCollectionViewLayout(twoColumnLayout, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = twoColumnLayout
        CurrentLayout.sharedInstance.layout = .twoColumn
        self.collectionView.register(MyCell.self, forCellWithReuseIdentifier: reusedCollectionViewCellIdentiier)
        self.collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: reusedCollectionViewCellIdentiier, for: indexPath) as! MyCell
        cardCell.Thumbnail.contentMode = .scaleAspectFill
        cardCell.Thumbnail.backgroundColor = UIColor.darkGray
        cardCell.Thumbnail.image = UIImage(named: "space.jpeg");
        return cardCell
    }
    
}

