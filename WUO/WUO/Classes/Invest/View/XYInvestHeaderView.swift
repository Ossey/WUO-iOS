//
//  XYInvestHeaderView.swift
//  WUO
//
//  Created by mofeini on 17/1/23.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYInvestHeaderView: UIView {

    // MARK: - 数据源及模型对象
    var figureSpecialList : [XYFigureSpecial]? {
        didSet {
        
        }
    }
    var headerLineItem : XYHeaderLineItem? {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
