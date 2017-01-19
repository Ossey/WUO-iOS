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
    lazy var investBtn : UIButton = {
        return UIButton();
    }()
    lazy var avatarView : UIButton = {
        return UIButton();
    }()
    lazy var title_label : UILabel = {
        return UILabel();
    }()
    lazy var contentLabel : UILabel = {
        return UILabel();
    }()
    lazy var jobLabel : UILabel = {
        return UILabel();
    }()
    lazy var pictureCollectionView : XYPictureCollectionView = {
        return XYPictureCollectionView();
    }()
    lazy var cornerImageView : UIImageView = {
        return UIImageView();
    }()
    lazy var videoImgView : XYVideoImgView = {
        return XYVideoImgView();
    }()
    
    lazy var topicNameLabel : UILabel = {
        return UILabel()
    }()
    
    lazy var readCountBtn : UIButton = {
        return UIButton()
    }()
    
    lazy var nameLabel : UILabel = {
        return UILabel()
    }()
    
    
    
    // MARK: - 模型属性
    var trendDetailViewModel : XYTrendDetailViewModel? {
        didSet {
            
            if let item = trendDetailViewModel?.item {
                avatarView.sd_setBackgroundImage(with: item.headerImageURL, for: .normal, placeholderImage: nil, options: .lowPriority)
                
                nameLabel.text = item.name
                jobLabel.text = item.job
                title_label.text = item.title
                contentLabel.text = item.content
                topicNameLabel.text = item.topicName
                
                pictureCollectionView.item = item
                pictureCollectionView.isHidden = item.imgCount == 0
                videoImgView.item = item
                videoImgView.isHidden = item.videoImgFullURL == nil
                
                readCountBtn.setTitle("\(item.readCount)" + "人预览", for: .normal)
 
            }
        }
    }
    
    
    // MARK: - 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI();
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let trendDetailViewModel = trendDetailViewModel else {
            return
        }
        
        avatarView.frame = trendDetailViewModel.avatarViewFrame!
        cornerImageView.frame = CGRect.init(x: 0, y: 0, width: trendDetailViewModel.avatarViewFrame!.width+5, height: trendDetailViewModel.avatarViewFrame!.height+5)
        cornerImageView.center = self.avatarView.center;
        
        nameLabel.frame = trendDetailViewModel.nameLabelFrame!
        jobLabel.frame = trendDetailViewModel.jobLabelFrame!
        investBtn.frame = trendDetailViewModel.investBtnFrame!
        topicNameLabel.frame = trendDetailViewModel.topicNameLabelFrame!
        title_label.frame = trendDetailViewModel.title_labelFrame!
        contentLabel.frame = trendDetailViewModel.contentLableFrame!
        
        pictureCollectionView.frame = trendDetailViewModel.picCollectionViewFrame!
        videoImgView.frame = trendDetailViewModel.videoImgViewFrame!
        
        readCountBtn.frame = trendDetailViewModel.readCountBtnFrame!
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
        pictureCollectionView.backgroundColor = COLOR_GLOBAL_CELL();
        pictureCollectionView.sizeForItemAtIndexPath = { (indexPath, layout, collectionView) -> CGSize in
            return (self.trendDetailViewModel?.item?.imgList[(indexPath?.row)!].imgScaleSize)!
        }
        addSubview(pictureCollectionView)
        
        // 视频图片展示
        videoImgView.isHidden = true
        videoImgView.tag = NSIntegerMax
        videoImgView.contentMode = .scaleAspectFill
        videoImgView.backgroundColor = COLOR_LIGHTGRAY()
        addSubview(videoImgView)
        
        // name
        nameLabel.font = FontWithSize(s: SIZE_FONT_NAME)
        nameLabel.textColor = COLOR_NAME_TEXT()
        addSubview(nameLabel)
        
        // job
        jobLabel.font = FontWithSize(s: SIZE_FONT_SUBTITLE)
        jobLabel.textColor = COLOR_JOB_TEXT()
        addSubview(jobLabel)
        
        // read
        readCountBtn.setTitleColor(COLOR_READCOUNT_TEXT, for: .normal)
        readCountBtn.setImage(UIImage.init(named: "Home_trendsReadCount"), for: .normal)
        readCountBtn.titleLabel?.font = FontWithSize(s: 8)
        addSubview(readCountBtn)
        
        // title
        title_label.textColor = COLOR_TITLE_TEXT()
        title_label.numberOfLines = 0
        title_label.font = FontWithSize(s: SIZE_FONT_TITLE)
        addSubview(title_label)
        
        // content
        contentLabel.font = FontWithSize(s: SIZE_FONT_CONTENT)
        contentLabel.numberOfLines = 0
        contentLabel.textColor = COLOR_CONTENT_TEXT()
        addSubview(contentLabel)
        
        // topicName
        topicNameLabel.font = FontWithSize(s: SIZE_FONT_CONTENT)
        topicNameLabel.numberOfLines = 0
        topicNameLabel.textColor = COLOR_CONTENT_TEXT()
        addSubview(topicNameLabel)


    }
    
}

// MARK: - 事件监听
extension XYTrendDetailHeaderView {
    
    func avatarViewClick() -> Void {
        
    }

}

//extension  XYPictureCollectionViewDataSource {
//    
//    @available(iOS 6.0, *)
//    public func pictureCollectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath!) -> CGSize {
//        
//    }
//
//    
//}
