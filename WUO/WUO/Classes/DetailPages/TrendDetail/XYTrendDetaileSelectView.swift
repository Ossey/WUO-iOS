//
//  XYTrendDetaileSelectView.swift
//  WUO
//
//  Created by mofeini on 17/1/20.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYTrendDetaileSelectView: UITableViewHeaderFooterView {

    lazy var labelView : XYTrendDetailLabelView = {
        let labelView = XYTrendDetailLabelView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENT_W(), height: SIZE_TREND_DETAIL_SELECTVIEW_H), delegate: nil, channelCates: nil, rightBtnWidth: 0)
        
        labelView.itemNameKey = "labelName"
        labelView.itemImageNameKey = "labelEname"
        return labelView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.addSubview(labelView)
        // 这句代码，尽然引发labelView不能响应事件，肯定是frame不正确导致的，郁闷了
//        labelView.frame = contentView.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
