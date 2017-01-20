//
//  XYTrendDetailTableView.swift
//  WUO
//
//  Created by mofeini on 17/1/19.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYTrendDetailTableView: UITableView {

    let cellIdentifier = "CELL"
    let headFooterViewIdentifier = "headFooterViewIdentifier"
    
    lazy var labelArr : [[String: String]] = {
        let dict1 = ["labelName": "分享 0"]
        let dict2 = ["labelName": "评论 0"]
        let dict3 = ["labelName": "点赞 0"]
        let dict4 = ["labelName": ""]
        let dict5 = ["labelName": ""]
        let dict6 = ["labelName": ""]
        let dict7 = ["labelName": "打赏 0"]
        let labelArr = [dict1, dict2, dict3, dict4, dict5, dict6, dict7]
        return labelArr
    }()
    
    var trendDetailViewModel : XYTrendDetailViewModel? {
        didSet {
            guard let trendDetailViewModel = trendDetailViewModel  else {
                return
            }
            guard let headerViewHeght = trendDetailViewModel.headerViewHeght else {
                return
            }
            headerView.frame.size.height = headerViewHeght
            headerView.trendDetailViewModel = trendDetailViewModel
            tableHeaderView = headerView
            labelArr[0]["labelName"] = "分享 " + "\((trendDetailViewModel.item?.shareCount)!)"
            labelArr[1]["labelName"] = "评论 " + "\((trendDetailViewModel.item?.commentCount)!)"
            labelArr[2]["labelName"] = "点赞 " + "\((trendDetailViewModel.item?.praiseCount)!)"
            labelArr[6]["labelName"] = "打赏 " + "\((trendDetailViewModel.item?.rewardCount)!)"
            
        }
    }
    
    lazy var headerView : XYTrendDetailHeaderView = {
        let headerView = XYTrendDetailHeaderView()
        return headerView
    }()
    
    lazy var selectView : XYTrendDetaileSelectView = {
        let selectView = XYTrendDetaileSelectView(reuseIdentifier: self.cellIdentifier)
        // 当有数据时才去设置selectView
        selectView.labelView.channelCates = NSMutableArray.init(array: self.labelArr)
        selectView.labelView.selectedIndex = 1
        selectView.labelView.delegate = self
        return selectView
    }()
    
    
    override init(frame: CGRect, style: UITableViewStyle) {

        super.init(frame: frame, style: style)
        
        setupUI()
        self.dataSource = self
        self.delegate = self
        self.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        self.register(XYTrendDetaileSelectView.classForCoder(), forHeaderFooterViewReuseIdentifier: headFooterViewIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI界面
extension XYTrendDetailTableView {

    func setupUI() -> Void {
        
        backgroundColor = TableViewBgColor
        headerView.backgroundColor = COLOR_GLOBAL_CELL()
    }
}

extension XYTrendDetailTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return self.selectView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SIZE_TREND_DETAIL_SELECTVIEW_H
    }
    
}

extension XYTrendDetailTableView: XYCateTitleViewDelegate {
    
    func cateTitleView(_ view: XYCateTitleView, didSelectedItem index: Int) {
        
    }
    
    func cateTitleView(_ view: XYCateTitleView, didSelectedItem btn: UIButton, cname: String) {
        
        
    }
}
