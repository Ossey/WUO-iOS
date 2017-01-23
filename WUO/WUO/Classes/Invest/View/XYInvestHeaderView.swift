//
//  XYInvestHeaderView.swift
//  WUO
//
//  Created by mofeini on 17/1/23.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYInvestHeaderView: UIView {
    
    // MARK: - 控件
    /// 人物专刊
    lazy var figureSpecialView : XYFigureSpecialView = {
        let view = XYFigureSpecialView()
        self.addSubview(view)
        return view
    }()
    
    /// headerLine
    lazy var headerLine : XYHeaderLineView = {
        let view = XYHeaderLineView()
        self.addSubview(view)
        return view
    }()
    

    // MARK: - 数据源及模型对象
    var figureSpecialList : [XYFigureSpecial]? {
        didSet {
            figureSpecialView.figureSpecialList = figureSpecialList
        }
    }
    var headerLineItem : XYHeaderLineItem? {
        didSet {
            headerLine.headerLineItem = headerLineItem
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension XYInvestHeaderView {
    
    func setupUI() -> Void {
        
        let margin : CGFloat = 8.0
        
        figureSpecialView.backgroundColor = UIColor.white
        headerLine.backgroundColor = UIColor.white
        
        headerLine.mas_makeConstraints { (make) in
            make?.left.right().equalTo()(self)?.setOffset(0)
            make?.bottom.equalTo()(self)?.setOffset(-margin)
            make?.height.equalTo()(50)
        }
        figureSpecialView.mas_makeConstraints { (make) in
            make?.top.left().right().equalTo()(self)?.setOffset(0)
            make?.bottom.equalTo()(self.headerLine.mas_top)?.setOffset(-margin)

        }
    }
}
