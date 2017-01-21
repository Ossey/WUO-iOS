//
//  XYInvestViewCell.swift
//  WUO
//
//  Created by mofeini on 17/1/21.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYInvestViewCell: UITableViewCell {

    // MARK: - 属性
    @IBOutlet weak var avatarView: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var beGmCount_label: UILabel!
    @IBOutlet weak var earningsGoldCoin_label: UILabel!
    @IBOutlet weak var fansCount_label: UILabel!
    @IBOutlet weak var investBtn: UIButton!
    @IBOutlet weak var picCollectionView: XYInvestPicView!
    lazy var cornerImageView : UIImageView = {
        return UIImageView();
    }()
    

    
    var foundUser : XYFoundUser? {
        didSet {
            
            guard let foundUser = foundUser else {
                print("没有数据")
                return
            }
            
            avatarView.sd_setBackgroundImage(with: foundUser.headImageURL, for: .normal, placeholderImage: UIImage.init(named: "mine_HeadImage"), options: .lowPriority)
            nameLabel.text = foundUser.name
            jobLabel.text = foundUser.jobStr
            if let beGmCount = foundUser.beGmCount  {
               beGmCount_label.text = "\(beGmCount)" + "投资人"
            }
            if let earningsGoldCoin = foundUser.earningsGoldCoin  {
                
                earningsGoldCoin_label.text = "赚取" + "\(earningsGoldCoin)" + "金币"
            }
            if let fansCount = foundUser.fansCount  {
                
                fansCount_label.text = "\(fansCount)" + "粉丝"
            }
            
            guard let imgList = foundUser.imgList else {
                foundUser.cellHeight = 180 - picCollectionView.frame.height
                picCollectionView.isHidden = true
                return
            }
            
            // 问题：当第一次加载xib时，不管怎么设置都是按照xib的高度算，只要滑动后才会按照我的计算
            // 暂时的解决办法：让xib中cell的高度与我们手动设置的高度相同
            picCollectionView.isHidden = imgList.count == 0
            if imgList.count > 0 {
                picCollectionView.imgList = imgList;
                picCollectionView.isHidden = false
                foundUser.cellHeight = 180
            } else {
                
                foundUser.cellHeight = 180 - picCollectionView.frame.height
                picCollectionView.isHidden = true
            }
        
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        
    }
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - 事件
extension XYInvestViewCell {

  
}

// MARK: - 设置UI
extension XYInvestViewCell {
    
    func setupUI() -> Void {
        
//        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.autoresizingMask = []
    
        let layout = picCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        // 由于第一次进入显示此界面时，获取到的picCollectionView的父控件的frame是不准确的，打印为320，当然滑动屏幕后打印宽度就准确了，所以使用屏幕宽度来计算
        let wh = (SCREENT_W() - 5 * 5) / 4
        layout.itemSize = CGSize(width: wh, height: picCollectionView.frame.height)
        layout.minimumInteritemSpacing = 5
        layout.minimumInteritemSpacing = 5
        print(picCollectionView.frame.height)
        
        selectionStyle = .none
        
        // 镂空的圆形图片盖在头像上面，目的是让头像显示为圆形
        cornerImageView.image = UIImage(named: "corner_circle")
        cornerImageView.tag = NSIntegerMax;
        addSubview(cornerImageView)
        cornerImageView.isUserInteractionEnabled = true;
        
        investBtn.layer.cornerRadius = 5
        investBtn.layer.masksToBounds = true
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cornerImageView.frame = CGRect.init(x: 0, y: 0, width: avatarView.frame.width+5, height: avatarView.frame.height+5)
        cornerImageView.center = self.avatarView.center;
        

    }
}

// MARK: - 事件监听
extension XYInvestViewCell {
    
   
}
