//
//  XYTrendDetailLabelView.swift
//  WUO
//
//  Created by mofeini on 17/1/20.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYTrendDetailLabelView: XYCateTitleView {

    override init(frame: CGRect, delegate: Any?, channelCates: [[AnyHashable : Any]]?, rightBtnWidth: CGFloat) {
        super.init(frame: frame, delegate: delegate, channelCates: channelCates, rightBtnWidth: rightBtnWidth)
        
        itemWidth = SCREENT_W() / 7
        titleItemFont = FontWithSize(s: 8)
        itemScale = 0.0
        underLineBackgroundColor = COLOR_GLOBAL_GREEN()
        separatorImage = UIImage()
        backgroundColor = COLOR_GLOBAL_CELL()
    }

}
