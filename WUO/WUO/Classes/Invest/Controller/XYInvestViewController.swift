//
//  XYInvestViewController.swift
//  WUO
//
//  Created by mofeini on 17/1/20.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

/**
 * 问题1：当没有网络时，点击TrendLabel时，会出现奔溃
 * 原因：经分析，这是因为在数据加载失败时(包含没有网络)，未对数据源进行刷新导致了不同的TrendLabel对应的数据源，未更新数据，导致数组越界
 * 解决方法：即使网络加载失败时，也要刷新数据源
 */

class XYInvestViewController: UIViewController {
    
    // MARK: - 数据源
    /// 用户数据
    lazy var dataList = [String: [XYFoundUser]]()
    /// 人物专刊
    var figureSpecialList = [XYFigureSpecial]() {
        didSet {
            
            /// 当加载到人物专刊数据时，设置tableView的头部视图
            
            if figureSpecialList.count > 0 && self.tableView.tableHeaderView == nil {
                self.tableView.tableHeaderView = headerView
            }
            
        }
    }
    /// 头条
    lazy var headerLineList = [[String: Any]]()
    /// TrendLabel数据源
    var labelNameList : NSArray? {
        didSet {
            
            if let count = self.labelNameList?.count  {
                self.selectView?.trendLabelView.itemWidth = (self.selectView?.trendLabelView.frame.width)! / CGFloat(count)
            }
        }
    }
    
    // MARK: - 属性
    /// 点击TrendLabel时对应的标题类型，用于向服务器请求对应的数据的字段
    var searchLabel : String? {
        didSet {
            
            guard let searchLabel = searchLabel else {
                return
            }
            
            // 创建数据源容器：根据用户选中的标题信息，创建对应的容器
            if dataList.count == 0 {
                let datas : [XYFoundUser] = [XYFoundUser]()
                 dataList[searchLabel] = datas
            } else {
                if !dataList.keys.contains(searchLabel) {
                    let datas : [XYFoundUser] = [XYFoundUser]()
                    dataList[searchLabel] = datas
                }
            }
            
            // 当数据源中没有数据时再去服务器请求数据，不然就只刷新数据源即可
            if dataList[searchLabel]?.count == 0 {
                
                getAllFoundUser(idstamp: 0)
            } else {
                tableView.reloadData()
            }
            
        }
    }
    
    lazy var headerView : XYInvestHeaderView? = {
        let headerView = XYInvestHeaderView()
        headerView.frame.size.height = 200
        return headerView
    }()
    
    lazy var selectView : XYActiveTopicDetailSelectView? = {
        
        let selectView  = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: headerFooterIdentifier) as? XYActiveTopicDetailSelectView
        selectView?.trendLabelView.delegate = self
        selectView?.backgroundColor = UIColor.white
        selectView?.trendLabelView.backgroundColor = UIColor.white
        selectView?.trendLabelView.itemScale = 0.0
        selectView?.trendLabelView.underLineImage = UIImage()
        return selectView
    }()
    
    lazy var tableView : UITableView = {
        return UITableView()
    }()
    
    var idstamp : Int? {
        set {
        
        }
        get {
            if dataList.count == 0 {
                return 0
            }
            
            return dynamicInfo?.idstamp
        }
    }
    
    var dynamicInfo : XYHTTPResponseInfo? {
        get {
            guard let searchLabel = searchLabel  else {
                return nil
            }
            if let foundUsers = dataList[searchLabel] {
                if foundUsers.count > 0 {
                    return foundUsers.last?.responseInfo
                }
            }
            return nil
        }
    }
    
    
    // MARK: - 控制器view的生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        weak var weakSelf = self
        // 进入投资界面后先加载LabelName，获取完成后再用对应的值去请求数据
        getFoundUserLabel() {
            
            weakSelf?.selectView?.trendLabelView.channelCates = NSMutableArray(array: (weakSelf?.labelNameList)!)
            
        }
        
        tableView.mj_header = XYRefreshGifHeader {
            weakSelf?.prepareForLoadDataFromNetwork()
        }
        
        
        
        tableView.mj_footer = XYRefreshGifFooter {
            if let idsramp = self.idstamp {
                
                self.getAllFoundUser(idstamp: idsramp)
            }
        }
        
        tableView.gzwLoading {
            if weakSelf?.figureSpecialList.count == 0 {
                weakSelf?.getFigureSpecialFromNetwork()
            }
            if weakSelf?.headerLineList.count == 0 {
                weakSelf?.getHeaderLineFromNetwork()
            }
            weakSelf?.prepareForLoadDataFromNetwork()
        }
        
        // 获取头部的数据
        getFigureSpecialFromNetwork()
        getHeaderLineFromNetwork()
        
    }

}

// MARK: - 网络请求
extension XYInvestViewController {

    /// 获取人物专刊数据
    func getFigureSpecialFromNetwork() -> Void {
        
        WUOHTTPRequest.setActivityIndicator(true)
        WUOHTTPRequest.invest_getAllNew(fromIdstamp: 0) { (task, responseObj, error) in
            WUOHTTPRequest.setActivityIndicator(false)
            
            if error != nil {
                self.xy_showMessage("网络请求失败")
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
            let info = XYHTTPResponseInfo(dict: responseObj)
            if code == 0 {
                if let datas = responseObj["datas"] as? [[String: Any]] {
                    
                    if datas.count == 0 {
                        self.xy_showMessage("暂时没有数据")
                        return
                    }
                    for item in datas {
                        
                        self.figureSpecialList.append(XYFigureSpecial(dict: item, responseInfo: info!))
                    }
                    
                }
            }
        }
    }
    
    /// 获取头条数据
    func getHeaderLineFromNetwork() -> Void {
        
        WUOHTTPRequest.setActivityIndicator(true)
        WUOHTTPRequest.invest_getHeaderLine(fromType: 1) { (task, responseObj, error) in
            
            WUOHTTPRequest.setActivityIndicator(false)
            
            if error != nil {
                self.xy_showMessage("网络请求失败")
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
            let info = XYHTTPResponseInfo(dict: responseObj)
            if code == 0 {
                if let datas = responseObj["datas"] as? [[String: Any]] {
                    
                    if datas.count == 0 {
                        self.xy_showMessage("暂时没有数据")
                        return
                    }
                    for item in datas {
                        
                        self.figureSpecialList.append(XYFigureSpecial(dict: item, responseInfo: info!))
                    }
                    
                }
            }
            
        }
    }
    
    func prepareForLoadDataFromNetwork() -> Void {
        // 避免没有网络时，未获取到searchLaebl时，就去请求user数据，会导致确实searchLabel参数，请求失败
        let group = DispatchGroup()
        group.enter()
        
        if self.labelNameList == nil {
            self.getFoundUserLabel {
                self.selectView?.trendLabelView.channelCates = NSMutableArray(array: (self.labelNameList)!)
            }
        }
        if let searchLabel = self.searchLabel {
            self.dataList[searchLabel]?.removeAll()
        }
        
        group.leave()
        group.notify(queue: DispatchQueue.main, work: DispatchWorkItem.init(qos: DispatchQoS.default, flags: DispatchWorkItemFlags.assignCurrentContext, block: {
            
            self.getAllFoundUser(idstamp: 0)
        }))
    }
    
    func getFoundUserLabel(completeCallBack: @escaping () -> ()) -> Void {
        
        WUOHTTPRequest.setActivityIndicator(true)
        self.tableView.loading = true
        WUOHTTPRequest.invest_getFoundUserLabelFinishedCallBack { (task, responseObj, error) in
            
            if self.tableView.mj_header.isRefreshing() {
                self.tableView.mj_header.endRefreshing()
            }
            if self.tableView.mj_footer.isRefreshing() {
                self.tableView.mj_footer.endRefreshing()
            }
            WUOHTTPRequest.setActivityIndicator(false)
            
            if error != nil {
                self.xy_showMessage("网络请求失败")
                self.tableView.loading = false
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
                if let datas = responseObj["datas"] as? [[String: Any]] {
                    if datas.count == 0 {
                        self.xy_showMessage("暂时没有数据")
                        return
                    }
                    self.labelNameList = NSArray(array: datas)
                    if let callBack: () -> () = completeCallBack {
                        callBack()
                    }
                }
               
            }
        }
    }
    
    func getAllFoundUser(idstamp: Int) -> Void {
        
        guard let searchLabel = searchLabel else {
            return
        }
        
        WUOHTTPRequest.setActivityIndicator(true)
        tableView.loading = true
        WUOHTTPRequest.invset_getAllFoundUser(fromSerachLabel: searchLabel, idstamp: idstamp, finishedCallBack: { (task, responseObj, error) in
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            WUOHTTPRequest.setActivityIndicator(false)
            
            if error != nil {
                self.xy_showMessage("网络请求失败")
                self.tableView.reloadData()
                self.tableView.loading = false
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
                    self.xy_showMessage("暂时没有数据")
                    return
                }
                for obj in datas {
                
                    self.dataList[searchLabel]?.append(XYFoundUser(dict: obj, responseInfo: info!))
                }
            }
            
            self.tableView.reloadData()
            
        })
    }
}
private let headerFooterIdentifier = "XYActiveTopicDetailSelectView"
private let cellIdentifier = "XYInvestViewCell"

// MARK: - 设置UI
extension XYInvestViewController {
    
    func setupUI() -> Void {
        
        
        let searchBtn = UIButton(type: .custom)
        searchBtn.frame.size = CGSize(width: SCREENT_W(), height: 30)
        searchBtn.setTitle("请输入昵称", for: .normal)
        searchBtn.setImage(UIImage.init(named: "Nav_search"), for: .normal)
        searchBtn.backgroundColor = COLOR_INVEST_SEARCH_BG
        searchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        searchBtn.addTarget(self, action: #selector(jumpToSearch), for: .touchUpInside)
        navigationItem.titleView = searchBtn;
        
        let messageBtn = UIButton(type: .custom)
        messageBtn.setImage(UIImage.init(named: "Nav_message"), for: .normal)
        messageBtn.addTarget(self, action: #selector(jumpToChatList), for: .touchUpInside)
        messageBtn.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: messageBtn)
        
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "XYInvestViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.register(XYActiveTopicDetailSelectView.classForCoder(), forHeaderFooterViewReuseIdentifier: headerFooterIdentifier)
    }
}

// MARK: - 事件响应
extension XYInvestViewController {
    
    func jumpToChatList() -> Void {
        
    }
    
    func jumpToSearch() -> Void {
        
    }
}

// MARK: - TableView的代理和数据源方法
extension XYInvestViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let searchLabel = searchLabel else {
            return 0
        }
        
        guard let list = self.dataList[searchLabel] else {
            return 0
        }
        
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? XYInvestViewCell

        if let searchLabel = searchLabel {
            if let list = self.dataList[searchLabel]  {
                
                cell?.foundUser = list[indexPath.row]
            }
        }

        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let searchLabel = searchLabel else {
            return 0
        }
        
        guard let list = self.dataList[searchLabel] else {
            return 0
        }
        
        let item = list[indexPath.row]
        
        return item.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        guard let searchLabel = searchLabel else {
            return
        }
        
        guard let list = self.dataList[searchLabel] else {
            return
        }
        let item = list[indexPath.row]
        if let uid = item.uid {
            // 跳转到用户详情页
            let vc = XYUserDetailController(uid: uid, username: item.name)
            
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return selectView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
}

extension XYInvestViewController: XYCateTitleViewDelegate {
    
    func cateTitleView(_ view: XYCateTitleView, didSelectedItem btn: UIButton, cname: String) {
        
        searchLabel = cname
    }
    
    func cateTitleView(_ view: XYCateTitleView, cateTitleItemDidCreated itemCount: Int) {
        print(itemCount)
    }
}
