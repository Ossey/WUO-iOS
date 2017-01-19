//
//  XYTrendDetailHeaderView.swift
//  WUO
//
//  Created by mofeini on 17/1/19.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYTrendDetailHeaderView: UIView {
    
    // MARK: - 控件懒加载
    var investBtn : UIButton = {
        return UIButton();
    }()
    var avatarView : UIButton = {
        return UIButton();
    }()
    var title_label : UILabel = {
        return UILabel();
    }()
    var contentLabel : UILabel = {
        return UILabel();
    }()
    var jobLabel : UILabel = {
        return UILabel();
    }()
    var pictureCollectionView : XYPictureCollectionView = {
        return XYPictureCollectionView();
    }()
    var cornerImageView : UIImageView = {
        return UIImageView();
    }()
    var videoImgView : XYVideoImgView = {
        return XYVideoImgView();
    }()
    
    var topicNameLabel : UILabel = {
        return UILabel()
    }()
    
    
    // MARK: - 模型属性
    var trendViewModel : XYTrendViewModel? {
        didSet {
        
        }
    }
    
    
    // MARK: - 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - UI
extension XYTrendDetailHeaderView {
    func setupUI() -> Void {
        
        self.clipsToBounds = true
        
        // 头像
        avatarView.backgroundColor = COLOR_GLOBAL_CELL();
        avatarView.isHidden = false
        avatarView.tag = NSIntegerMax
        avatarView.clipsToBounds = true
        addSubview(self.avatarView)
        avatarView .addTarget(self, action: #selector(XYTrendDetailHeaderView.avatarViewClick), for: .touchUpInside)
        
        // 镂空的圆形图片盖在头像上面，目的是让头像显示为圆形
        cornerImageView.center = avatarView.center
        cornerImageView.image = UIImage(named: "corner_circle")
        cornerImageView.tag = NSIntegerMax;
        addSubview(cornerImageView)
        cornerImageView.isUserInteractionEnabled = true;
        cornerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(XYTrendDetailHeaderView.avatarViewClick)))
        
        
        // 投资按钮
        investBtn.setTitle("投资", for: .normal)
        investBtn.backgroundColor = UIColor.black
        investBtn.titleLabel?.font = FontWithSize(s: 13)
        addSubview(investBtn)
        investBtn.layer.masksToBounds = true
        investBtn.layer.cornerRadius = 5;
        
        
        // 图片
        pictureCollectionView.tag = NSIntegerMax
        pictureCollectionView.isHidden = true
        pictureCollectionView.backgroundColor = COLOR_GLOBAL_CELL();
        addSubview(pictureCollectionView)

        // 视频图片展示
        videoImgView.isHidden = true
        videoImgView.tag = NSIntegerMax
        videoImgView.contentMode = .scaleAspectFill
        videoImgView.backgroundColor = COLOR_LIGHTGRAY()
        addSubview(videoImgView)
    }
}

// MARK: - 事件监听
extension XYTrendDetailHeaderView {
    
    func avatarViewClick() -> Void {
        
    }

}
