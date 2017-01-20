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
        
        let tableView = XYTrendDetailTableView()
        
        return tableView
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
        tableView.delegate = self
        setupUI()
    }
    
    
    deinit {
        print("XYTrendDetailController被销毁")
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
            self.automaticallyAdjustsScrollViewInsets = false
            tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
            // 设置了tableView的contentInset但是并未触发scrollViewDidScroll事件，虽然contentInset没有问题，但是导致初次进入界面时tableView的偏移量不对，所以手动设置tableView.contentOffset
            tableView.setContentOffset(CGPoint.init(x: 0, y: -64), animated: true)
            self.xy_rightButton = rightBtn
            self.xy_topBar.backgroundColor = UIColor.white
            xy_setBackBarTitle(nil, titleColor: UIColor.black, image: UIImage.init(named: "Login_backSel"), for: .normal)
 
            navigationController?.setNavigationBarHidden(true, animated: true)
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

extension XYTrendDetailController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
}
