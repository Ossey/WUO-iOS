//
//  XYInvestViewController.swift
//  WUO
//
//  Created by mofeini on 17/1/20.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

import UIKit

class XYInvestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        WUOHTTPRequest.invset_getAllFoundUser(fromSerachLabel: "投资榜", idstamp: "0", finishedCallBack: { (task, responseObj, error) in
            
        })
    }


}

let cellIdentifier = "XYInvestViewCell"


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
        
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 144
        tableView.register(UINib.init(nibName: "XYInvestViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
}

// MARK: - 事件响应
extension XYInvestViewController {
    
    func jumpToChatList() -> Void {
        
    }
    
    func jumpToSearch() -> Void {
        
    }
}

extension XYInvestViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? XYInvestViewCell
        
        return cell!
        
    }
}
