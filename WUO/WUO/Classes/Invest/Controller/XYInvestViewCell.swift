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
    @IBOutlet weak var picCollectionView: XYPictureCollectionView!
    lazy var cornerImageView : UIImageView = {
        return UIImageView();
    }()
    
    var foundUser : XYFoundUser? {
        didSet {
            avatarView.sd_setBackgroundImage(with: foundUser?.headImageURL, for: .normal, placeholderImage: UIImage.init(named: "mine_HeadImage"), options: .lowPriority)
            nameLabel.text = foundUser?.name
            jobLabel.text = foundUser?.job
            beGmCount_label.text = "\(foundUser?.beGmCount)" + "投资人"
            earningsGoldCoin_label.text = "赚取" + "\(foundUser?.earningsGoldCoin)" + "金币"
            fansCount_label.text = "\(foundUser?.fansCount)" + "粉丝"
            
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
        
        selectionStyle = .none
    
        // 镂空的圆形图片盖在头像上面，目的是让头像显示为圆形
        cornerImageView.image = UIImage(named: "corner_circle")
        cornerImageView.tag = NSIntegerMax;
        addSubview(cornerImageView)
        cornerImageView.isUserInteractionEnabled = true;
        cornerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(XYTrendDetailHeaderView.avatarViewClick)))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cornerImageView.frame = CGRect.init(x: 0, y: 0, width: avatarView.frame.width+5, height: avatarView.frame.height+5)
        cornerImageView.center = self.avatarView.center;
    }
}
