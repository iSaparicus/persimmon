//
//  TutorialViewController.swift
//  persimmon
//
//  Created by Sapar Jumabek on 10/18/15.
//  Copyright © 2015 Sapar Jumabek. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var currentCell: Int!
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentCell = 0
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: CGRectGetWidth(self.view.frame), height: CGRectGetHeight(self.view.frame))
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.pagingEnabled = true;
        self.view.addSubview(collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        cell.backgroundColor = colorsArray[indexPath.row]
        cell.tag = indexPath.row
        return cell
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let cells = self.collectionView.visibleCells()
        let visibleCellTag = cells[0].tag
        if(visibleCellTag == 0){
            
        }else if(visibleCellTag == 6){
            
        }else{
            
        }
    }
}
