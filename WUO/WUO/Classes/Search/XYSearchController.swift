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
    lazy var searchResultDataList = [XYFoundUser]()
    /// 搜索使用的表视图
    lazy var searchResultView = UITableView()
    /// 搜索框输入的结果
    var inputText : String?
    /// 提示文字视图，当搜索结果为空时，在view中间显示提示用户信息
    lazy var tipLabel : UILabel = {
        let tipLabel = UILabel()
        tipLabel.text = "抱歉!没有找到您想找的人!"
        tipLabel.textColor = COLOR_LIGHTGRAY()
        tipLabel.font = FontWithSize(s: 16)
        tipLabel.textAlignment = .center
        return tipLabel
    }()
    
    var idstamp : Int? {
        get {
            if searchResultDataList.count == 0 {
                return 0
            }
            
            return searchResultDataList.last?.responseInfo?.idstamp
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // 让进入此控制器时，就让searchBar处于编辑状态
        searchBar.becomeFirstResponder()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    /// 设置searchBar的取消按钮文字
    func cancelButtonSetText() -> Void {
        for view in searchBar.subviews[0].subviews {
            if view.isKind(of: NSClassFromString("UINavigationButton")!) {
                if let btn = view as? UIButton {
                    btn.setTitle("取消", for: .normal)
                    btn.setTitle("搜索", for: .disabled)
                }
            }
        }
    }
}

private let cellIdentifier = "XYInvestViewCell"

extension XYSearchController {
    
    func setupUI() -> Void {
        
        setSearchBar()
        setSearchResultView()
    }
    
    func setSearchResultView() -> Void {
        searchResultView.frame = view.bounds
        view.addSubview(searchResultView)
        searchResultView.backgroundColor = COLOR_LIGHTGRAY()
        searchResultView.separatorStyle = .none
        searchResultView.dataSource = self
        searchResultView.delegate = self
        searchResultView.register(UINib.init(nibName: "XYInvestViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        searchResultView.mj_header = XYRefreshGifHeader(refreshingBlock: {
            if self.searchResultDataList.count != 0 {
                self.searchResultDataList.removeAll()
            }
            self.getAllFoundUserSerach()
        })
        
        searchResultView.mj_footer = XYRefreshGifFooter(refreshingBlock: { 
            self.getAllFoundUserSerach()
        })
    }
    
    func setSearchBar() -> Void {
        searchBar.image(for: .resultsList, state: .normal)
        searchBar.showsCancelButton = true
        searchBar.placeholder = "请输入昵称"
        navigationItem.titleView = searchBar
        cancelButtonSetText()
        navigationController?.navigationBar.tintColor = COLOR(r: 144, g: 144, b: 144, a: 1.0)
        
        /// 改变搜索框的颜色
        if let searchTf = searchBar.value(forKey: "_searchField") as? UITextField {
            searchTf.borderStyle = .none
            searchTf.backgroundColor = COLOR(r: 211, g: 211, b: 211, a: 1.0)
            searchTf.layer.cornerRadius = 3.0
            searchTf.layer.masksToBounds = true
            /// 取消左侧的搜索图标
            //            searchTf.leftViewMode = .never
            searchTf.textColor = UIColor.white
            
            /// 改变placeholder的颜色
            searchTf.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        }
        
        
        searchBar.delegate = self
    }
}

// MARK: - 事件监听
extension XYSearchController {
    
    func cancelClick() -> Void {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    

}

// MARK: - TableView数据源和代理方法
extension XYSearchController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResultDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? XYInvestViewCell
        
        cell?.foundUser = self.searchResultDataList[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if searchResultDataList.count == 0 {
            return 0
        }
        
        let item = searchResultDataList[indexPath.row]
        
        return item.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = searchResultDataList[indexPath.row]
        if let uid = item.uid {
            // 跳转到用户详情页
            let vc = XYUserDetailController(uid: uid, username: item.name)
            
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
    
}

// MARK: - UISearchBarDelegate
extension XYSearchController: UISearchBarDelegate {


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        inputText = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cancelClick()
    }
    
    /// 点击搜索按钮时调用 -- 当点击搜索按钮时，要情况上次搜索的容器内容
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.resignFirstResponder()
        
        if self.searchResultDataList.count != 0 {
            self.searchResultDataList.removeAll()
        }
        
        getAllFoundUserSerach()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchResultDataList.count != 0 {
            searchResultDataList.removeAll()
            searchResultView.reloadData()   
        }
    }
    
}

// MARK: - 网络请求
extension XYSearchController {
    
    func getAllFoundUserSerach(callBack: (() -> Swift.Void)? = nil) -> Void {
        
        WUOHTTPRequest.setActivityIndicator(true)
        WUOHTTPRequest.invest_getAllFoundUserSerach(fromSearchName: inputText, idstamp: idstamp!) { (task, responseObj, error) in
            
            if self.searchResultView.mj_header.isRefreshing() {
                self.searchResultView.mj_header.endRefreshing()
            }
            if self.searchResultView.mj_footer.isRefreshing() {
                self.searchResultView.mj_footer.endRefreshing()
            }
            WUOHTTPRequest.setActivityIndicator(false)
            
            if error != nil {
                self.xy_showMessage("网络请求失败")
                self.searchResultView.reloadData()
                return
            }
            
            guard let responseObj = responseObj as? [String: Any] else {
                print("找不到responseObj")
                return
            }
            
            guard let code = responseObj["code"] as? Int else {
                print("找不到code")
                return
            }
            if code == 0 {
                let info = XYHTTPResponseInfo(dict: responseObj)
                guard let datas = responseObj["datas"] as? [[String: Any]] else {
                    print("找不到datas")
                    return
                }
                if datas.count == 0 {
                    self.xy_showMessage("抱歉!没有找到您想找的人!")
                    if callBack != nil {
                        callBack!()
                    }
                    return
                }
                for obj in datas {
                    print(obj)
                    self.searchResultDataList.append(XYFoundUser(dict: obj, responseInfo: info!))
                }
            }
            
            self.searchResultView.reloadData()
            if callBack != nil {
                callBack!()
            }
        }
    }
    

}
