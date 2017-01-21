//
//  XYInvestPicView.swift
//  WUO
//
//  Created by mofeini on 17/1/21.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYInvestPicView: UICollectionView {

    public var imgList : [XYTrendImgItem]? {
        didSet {
            reloadData()
        }
    }
    
    var imgPathList : [String]? {
        get {
            guard let imgList = imgList else {
                return nil
            }
            var tempList : [String] = [String]()
            for item in imgList {
                tempList.append(item.imgFullURL.absoluteString)
            }
            return tempList
        }
    }
    
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    

}

let cellIdentifier = "XYPictureCollectionViewCell"


// MARK: - 设置UI界面
extension XYInvestPicView {
    
    func setupUI() -> Void {
        dataSource = self
        delegate = self
        scrollsToTop = false
        register(XYPictureCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: cellIdentifier)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
    }
}

extension XYInvestPicView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let imgList = imgList else {
            return 0;
        }
        
        return imgList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! XYPictureCollectionViewCell
        
        if let imgList = imgList {
            cell.imgItem = imgList[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        XYImageViewer.shareInstance().prepareImageURLStrList(imgPathList) { (indexPath) -> UIView? in
            return collectionView.cellForItem(at: indexPath!)
        }
        
        XYImageViewer.shareInstance().show(cell, currentImgIndex: indexPath.row)
        
    }
    
}

