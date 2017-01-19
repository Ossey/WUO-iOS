//
//  XYTrendDetailTableView.swift
//  WUO
//
//  Created by mofeini on 17/1/19.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYTrendDetailTableView: UITableView {

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
    
    override init(frame: CGRect, style: UITableViewStyle) {

        super.init(frame: frame, style: style)
        
        setupUI()
        
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
