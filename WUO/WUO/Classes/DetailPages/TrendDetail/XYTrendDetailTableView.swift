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
    
    lazy var labelArr : NSMutableArray = {
        let dict1 = ["labelName": "分享"]
        let dict2 = ["labelName": "评论"]
        let dict3 = ["labelName": "点赞"]
        let dict4 = ["labelName": ""]
        let dict5 = ["labelName": ""]
        let dict6 = ["labelName": ""]
        let dict7 = ["labelName": "打赏"]
        let labelArr = NSMutableArray()
        labelArr.add(dict1)
        labelArr.add(dict2)
        labelArr.add(dict3)
        labelArr.add(dict4)
        labelArr.add(dict5)
        labelArr.add(dict6)
        labelArr.add(dict7)
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
            
            
        }
    }
    
    lazy var headerView : XYTrendDetailHeaderView = {
        let headerView = XYTrendDetailHeaderView()
        return headerView
    }()
    
    lazy var selectView : XYTrendDetaileSelectView = {
        let selectView = XYTrendDetaileSelectView(reuseIdentifier: self.cellIdentifier)
        // 当有数据时才去设置selectView
        selectView.labelView.channelCates = self.labelArr
        selectView.labelView.selectedIndex = 1
        selectView.labelView.delegate = self
//        selectView.labelView.backgroundColor = TableViewBgColor
//        selectView.labelView.globalBackgroundColor = COLOR_GLOBAL_CELL()
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
