//
//  XYTrendDetailController.swift
//  WUO
//
//  Created by mofeini on 17/1/19.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYTrendDetailController: XYProfileBaseController {
    
    var trendDetailViewModel : XYTrendDetailViewModel?
    
    
    lazy var tableView : XYTrendDetailTableView = {
        
        return XYTrendDetailTableView()
    }()
    
    
    init(trendItem: XYTrendItem) {
        
        super.init(nibName: nil, bundle: nil)
        
        trendDetailViewModel = XYTrendDetailViewModel(item: trendItem, info: trendItem.info)
        tableView.trendDetailViewModel = trendDetailViewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.addSubview(tableView)
        tableView.frame = self.view.bounds
        
        setupUI()
    }
}

// MARK: - 设置UI界面
extension XYTrendDetailController {

    func setupUI() -> Void {
        
        let rightBtn = UIButton(type: .custom)
        rightBtn .setImage(UIImage.init(named: "Nav_more"), for: .normal)
        rightBtn.addTarget(self, action: #selector(moreEvent), for: .touchUpInside)
        rightBtn.sizeToFit()
        // 根据当前控制器所在导航控制器是不是XYCustomNavController判断，导航右侧按钮该显示在哪
        if navigationController?.classForCoder == XYCustomNavController.self {
            self.xy_rightButton = rightBtn
            self.xy_topBar.backgroundColor = UIColor.white
            xy_setBackBarTitle(nil, titleColor: UIColor.black, image: UIImage.init(named: "Login_backSel"), for: .normal)
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        }

    }
}

// MARK: - 事件响应
extension XYTrendDetailController {

    func moreEvent() -> Void {
        
    }
}
