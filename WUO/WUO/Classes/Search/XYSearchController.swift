//
//  XYSearchViewController.swift
//  WUO
//
//  Created by mofeini on 17/1/24.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYSearchController: UIViewController {
    
    // MARK: - 属性
    lazy var searchBar = UISearchBar()
    /// 存放搜索出来的结果的数组
    lazy var searchResultDataArray = [XYFoundUser]()
    /// 搜索使用的表视图控制器
    lazy var searchResultVc = UITableViewController()
    /// 搜索框输入的结果
    var inputText : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = COLOR_LIGHTGRAY()

        
        // 搜索框检测代理
//        searchResultsUpdater = self;
//        delegate = self;
//        searchBar.placeholder = "请输入昵称"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }

}

//extension XYSearchController: UISearchResultsUpdating, UISearchControllerDelegate {
//    
//    @available(iOS 8.0, *)
//    public func updateSearchResults(for searchController: UISearchController) {
//        
//        // 得到searchBar中的text
//        self.inputText = searchController.searchBar.text
//        
//        // 发送网络请求
//    }
//
//    
//}
