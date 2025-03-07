//
//  RSAPPPublishTableview.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/10.
//

import UIKit
import EmptyDataSet_Swift

protocol APPPublishTableProtocol: AnyObject {
    func startRefreshTableSource(tableView: RSAPPPublishTableview)
    func didSelectedTaskItem(_ model: RSAPPRequirementModel)
    func clickCellAction(sender: RSAPPLoadingButton, model: RSAPPRequirementModel?, tableView: RSAPPPublishTableview)
}

class RSAPPPublishTableview: UITableView {

    weak open var tabDelegate: APPPublishTableProtocol?
    open var searchCondition: String?
    
    private var _data_source: [RSAPPRequirementModel] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.separatorStyle = .none
        self.backgroundColor = .clear
        
        self.delegate = self
        self.dataSource = self
        self.emptyDataSetSource = self
        self.emptyDataSetDelegate = self
        self.register(RSAPPPublicjTaskTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(RSAPPPublicjTaskTableViewCell.self))
        
        self.addMJRefresh(addFooter: false) {[weak self] (isRefresh: Bool) in
            guard let _self = self else {
                return
            }
            
            _self.tabDelegate?.startRefreshTableSource(tableView: _self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadTaskModel(_ models: [RSAPPRequirementModel]) {
        self._data_source.removeAll()
        self._data_source.append(contentsOf: models)
        self.reloadData()
    }
}

extension RSAPPPublishTableview: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._data_source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(RSAPPPublicjTaskTableViewCell.self), for: indexPath) as? RSAPPPublicjTaskTableViewCell else {
            return UITableViewCell()
        }
        
        _cell.cellDelegate = self
        _cell.reloadCellSource(self._data_source[indexPath.row])
        return _cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tabDelegate?.didSelectedTaskItem(self._data_source[indexPath.row])
    }
}

// MARK: EmptyDataSetDelegate
extension RSAPPPublishTableview: EmptyDataSetDelegate, EmptyDataSetSource {
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        let emptyView = RSAPPEmptyView.init(frame: scrollView.bounds)
        scrollView.addSubview(emptyView)
        return emptyView
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return self.numberOfRows(inSection: 0) == .zero
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}

extension RSAPPPublishTableview: APPPublicjTaskTableViewCellProtocol {
    func didClickActionButton(sender: RSAPPLoadingButton, model: RSAPPRequirementModel?) {
        self.tabDelegate?.clickCellAction(sender: sender, model: model, tableView: self)
    }
}
