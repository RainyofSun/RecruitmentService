//
//  RSAPPNotificationViewController.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

class RSAPPNotificationViewController: APBaseViewController, HideNavigationBarProtocol {

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.plain)
        view.separatorStyle = .none
        view.backgroundColor = .clear
        return view
    }()
    
    private var notification_models: [RSAPPNotificationModel] = []
    private var total_notification_models: [RSAPPNotificationModel] = []
    
    override func buildViewUI() {
        super.buildViewUI()
        self.contentView.isHidden = true
        
        self.tableView.register(RSAPPNotificationTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(RSAPPNotificationTableViewCell.self))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.pageRequest()
        
        self.tableView.addMJRefresh(addFooter: true) {[weak self] (isRefresh: Bool) in
            isRefresh ? self?.refreshNotificationSource() : self?.loadMoreData()
        }
        
        self.view.addSubview(self.tableView)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.topView.snp.bottom).offset(PADDING_UNIT)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-UIDevice.xp_tabBarFullHeight() - PADDING_UNIT)
        }
    }
    
    override func pageRequest() {
        super.pageRequest()
        NetworkRequest(RSAPPNetworkAPI.queryRequirementList(key: REQUIREMENT_INFO_KEY), modelType: [RSAPPNotificationModel].self) { [weak self] (res: [HandyJSON?], res1: SuccessResponse) in            
            guard let _json_array = res1.arrayJSON?.first as? [Any] else {
                return
            }
            
            guard let _models = [RSAPPNotificationModel].deserialize(from: _json_array) as? [RSAPPNotificationModel] else {
                return
            }
            
            self?.total_notification_models.append(contentsOf: _models)
            self?.tableView.refresh(begin: true)
        } failureCallback: { _ in
            if let path = Bundle.main.path(forResource: "task", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let jsonArray = jsonObject as? [[String:Any]], let _models = [RSAPPNotificationModel].deserialize(from: jsonArray) as? [RSAPPNotificationModel] {
                        self.total_notification_models.append(contentsOf: _models)
                    }
                    self.tableView.refresh(begin: true)
                } catch {
                    
                }
            }
        }
    }
}

private extension RSAPPNotificationViewController {
    func refreshNotificationSource() {
        self.tableView.resetNoMoreData()
        self.tableView.refresh(begin: false)
        self.total_notification_models.shuffle()
        self.notification_models.removeAll()
        self.notification_models.append(contentsOf: self.total_notification_models.prefix(20))
        self.tableView.reloadData()
    }
    
    func loadMoreData() {
        if self.notification_models.count == self.total_notification_models.count {
            self.tableView.loadMore(begin: false, noData: true)
            return
        }
        let _count = self.notification_models.count
        var _target_count = _count + 20
        if _target_count > self.total_notification_models.count {
            _target_count = self.total_notification_models.count
        }
        CocoaLog.debug("--- \(self.notification_models.count) ------ \(_target_count) ---- \(self.total_notification_models.count)")
        self.notification_models.append(contentsOf: self.total_notification_models[_count...(_target_count - 1)])
        self.tableView.reloadData()
        self.tableView.loadMore(begin: false)
    }
}

extension RSAPPNotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notification_models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(RSAPPNotificationTableViewCell.self), for: indexPath) as? RSAPPNotificationTableViewCell else {
            return UITableViewCell()
        }
        
        if let _model = self.notification_models[indexPath.row].worker, let _task = self.notification_models[indexPath.row].task {
            _cell.reloadCellSource(model: _model, type: _task.requirementType ?? .WeiXiu)
        }
        
        return _cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(RSAPPNotificationDetailViewController(taskkModel: self.notification_models[indexPath.row]), animated: true)
    }
}

// MARK: EmptyDataSetDelegate
extension RSAPPNotificationViewController: EmptyDataSetDelegate, EmptyDataSetSource {
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        let emptyView = RSAPPEmptyView.init(frame: scrollView.bounds)
        scrollView.addSubview(emptyView)
        return emptyView
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return self.tableView.numberOfRows(inSection: 0) == .zero
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}
