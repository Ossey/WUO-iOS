//
//  XYFigureSpecialView.swift
//  WUO
//
//  Created by mofeini on 17/1/23.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYFigureSpecialView: UIView {

    // MARK: - 数据源
    var figureSpecialList : [XYFigureSpecial]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - 子控件
    lazy var accessryBtn : XYaccessryBtn = {
        let button =  XYaccessryBtn(type: .custom)
        self.addSubview(button)
        return button
    }()
    
    lazy var layout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    lazy var collectionView : UICollectionView = {
        
       let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        self.addSubview(view)
        view.backgroundColor = UIColor.white
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsetsMake(0, 8.0, 0, 0);
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        accessryBtn.setTitle("人物专刊", for: .normal)
        accessryBtn.setImage(UIImage.init(named: "accessry"), for: .normal)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(XYFigureSpecialCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: cellIndentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        accessryBtn.mas_makeConstraints { (make) in
            make?.left.top().right().equalTo()(self)?.setOffset(0)
            make?.height.equalTo()(50)
        }
        
        collectionView.mas_makeConstraints { (make) in
            make?.left.right().equalTo()(self)?.setOffset(0)
            make?.top.equalTo()(self.accessryBtn.mas_bottom)?.setOffset(0)
            make?.bottom.equalTo()(self)?.setOffset(-8)
        }
        
        layout.itemSize = CGSize(width: 100, height: collectionView.frame.height)
    }

}

let cellIndentifier = "XYFigureSpecialCollectionViewCell"

extension XYFigureSpecialView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let figureSpecialList = figureSpecialList else {
            return 0
        }
        return figureSpecialList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIndentifier, for: indexPath) as! XYFigureSpecialCollectionViewCell
        
        if let figureSpecialList = figureSpecialList {
            cell.figureSpecial = figureSpecialList[indexPath.row]
        }
        return cell
    }
}

class XYaccessryBtn: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitleColor(UIColor.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel?.frame.origin.x = 10
        if let imageView = imageView {
            
            self.imageView?.frame.origin.x = self.frame.width - imageView.frame.width - 10
        }
        
        // 这里不能调用sizeToFit 一旦调用：按钮的宽度将自动适应为文字的宽度+图片的宽度
        //sizeToFit()
    }
}

class XYFigureSpecialCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = COLOR_LIGHTGRAY()
        return imageView
    }()
    
    var figureSpecial : XYFigureSpecial? {
        didSet {
            imageView.sd_setImage(with: figureSpecial?.logoFullURL)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(imageView)
        imageView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self.contentView)?.setOffset(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
