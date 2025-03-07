//
//  RSAPPPublishViewController.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

class RSAPPPublishViewController: APBaseViewController, HideNavigationBarProtocol {

    private lazy var addRequirementBtn: UIButton = UIButton.buildButton(title: RSAPPLanguage.localValue("publish_top_right_item"), titleColor: BLUE_COLOR_1874FF, titleFont: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium), backgroudColor: .clear)
    private lazy var menuView: RSAPPPublishMenuView = RSAPPPublishMenuView(frame: CGRectZero)
    
    private lazy var allTableView: RSAPPPublishTableview = RSAPPPublishTableview(frame: CGRect(origin: CGPointZero, size: CGSize(width: ScreenWidth, height: ScreenHeight - UIDevice.xp_navigationFullHeight() - UIDevice.xp_safeDistanceBottom() - PADDING_UNIT * 27)), style: UITableView.Style.plain)
    private lazy var recruitmentTableView: RSAPPPublishTableview = RSAPPPublishTableview(frame: CGRect(origin: CGPoint(x: ScreenWidth, y: 0), size: self.allTableView.size), style: UITableView.Style.plain)
    private lazy var beReleasedTableView: RSAPPPublishTableview = RSAPPPublishTableview(frame: CGRect(origin: CGPoint(x: ScreenWidth * 2, y: 0), size: self.allTableView.size), style: UITableView.Style.plain)
    private lazy var recruitmentEndedTableView: RSAPPPublishTableview = RSAPPPublishTableview(frame: CGRect(origin: CGPoint(x: ScreenWidth * 3, y: 0), size: self.allTableView.size), style: UITableView.Style.plain)
    
    override func buildViewUI() {
        super.buildViewUI()
        
        self.addRequirementBtn.addTarget(self, action: #selector(addNewRequirement(sender: )), for: UIControl.Event.touchUpInside)
        
        self.menuView.menuDelegate = self
        
        self.allTableView.tabDelegate = self
        self.recruitmentTableView.tabDelegate = self
        self.beReleasedTableView.tabDelegate = self
        self.recruitmentEndedTableView.tabDelegate = self
        
        self.allTableView.searchCondition = ALL_REQUIREMENT_KEY
        self.recruitmentTableView.searchCondition = PUBLISH_REQUIREMENT_FUZZY_QUERY_KEY
        self.beReleasedTableView.searchCondition = SAVE_REQUIREMENT_FUZZY_QUERY_KEY
        self.recruitmentEndedTableView.searchCondition = STOP_REQUIREMENT_FUZZY_QUERY_KEY
        
        self.allTableView.tag = 1000
        self.recruitmentTableView.tag = 1001
        self.beReleasedTableView.tag = 1002
        self.recruitmentEndedTableView.tag = 1003
        
        self.buildRightItem(rightItem: self.addRequirementBtn)
        self.view.addSubview(self.menuView)
        self.contentView.addSubview(self.allTableView)
        self.contentView.addSubview(self.recruitmentTableView)
        self.contentView.addSubview(self.beReleasedTableView)
        self.contentView.addSubview(self.recruitmentEndedTableView)
        self.contentView.contentSize = CGSize(width: ScreenWidth * 4, height: 0)
        self.contentView.isPagingEnabled = true
        self.contentView.isScrollEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(swicthMenu(notification: )), name: APPGoToPublishTabNotification, object: nil)
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.menuView.snp.makeConstraints { make in
            make.top.equalTo(self.topView.snp.bottom).offset(PADDING_UNIT)
            make.left.equalToSuperview()
            make.width.equalTo(ScreenWidth)
        }
        
        self.contentView.snp.remakeConstraints { make in
            make.top.equalTo(self.menuView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-UIDevice.xp_tabBarFullHeight())
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.allTableView.refresh(begin: true)
    }
}

private extension RSAPPPublishViewController {
    func queryTask(_ tableView: RSAPPPublishTableview) {
        guard let _condition = tableView.searchCondition else {
            return
        }
        
        NetworkRequest(RSAPPNetworkAPI.queryRequirementList(key: _condition), modelType: [RSAPPRequirementModel].self) { (res: [HandyJSON?], res1: SuccessResponse) in
            tableView.refresh(begin: false)
            guard let _models = res as? [RSAPPRequirementModel] else {
                return
            }
            
            tableView.reloadTaskModel(_models)
        }
    }
}

extension RSAPPPublishViewController: APPPublishMenuProtocol {
    func didSelectedMenuItem(idx: NSInteger) {
        self.contentView.setContentOffset(CGPoint(x: ScreenWidth * CGFloat(idx), y: .zero), animated: true)
        if let _tab = self.contentView.viewWithTag((1000 + idx)) as? RSAPPPublishTableview {
            _tab.refresh(begin: true)
        }
    }
}

extension RSAPPPublishViewController: APPPublishTableProtocol {
    func startRefreshTableSource(tableView: RSAPPPublishTableview) {
        self.queryTask(tableView)
    }
    
    func didSelectedTaskItem(_ model: RSAPPRequirementModel) {
        self.navigationController?.pushViewController(RSAPPRequirementDetailVC(status: model.status, requirementModel: model, showNext: model.status != .RecruitmentEnded), animated: true)
    }
    
    func clickCellAction(sender: RSAPPLoadingButton, model: RSAPPRequirementModel?, tableView: RSAPPPublishTableview) {
        guard let _task_model = model, let _original_time_key = _task_model.requirementTimeKey, let _original_key = _task_model.requirementKey else {
            return
        }
        
        sender.startAnimation()
        
        if _task_model.status == .Published {
            _task_model.status = .RecruitmentEnded
            _task_model.requirementKey = STOP_REQUIREMENT_KEY + _original_time_key
            guard let _json = _task_model.toJSON(), let _key = _task_model.requirementKey else {
                return
            }
            
            CocoaLog.debug("--------- 点击Next, 发布或者停止招工信息 -----------\n \(_key) \n -------------------")
            NetworkRequest(RSAPPNetworkAPI.deleteRequirementData(keys: [_original_key]), modelType: RSAPPBaseResponseModel.self) { _, _ in
                NetworkRequest(RSAPPNetworkAPI.SaveRequirementParams(paramsJson: _json, key: _key), modelType: RSAPPBaseResponseModel.self) {[weak self] (res: HandyJSON, res1: SuccessResponse) in
                    sender.stopAnimation()
                    self?.view.makeToast(RSAPPLanguage.localValue("alert_stop_success"), position: .center)
                    tableView.refresh(begin: true)
                }
            }
        } else {
            _task_model.status = .Published
            _task_model.requirementKey = PUBLISH_REQUIREMENT_KEY + _original_time_key
            guard let _json = _task_model.toJSON(), let _key = _task_model.requirementKey else {
                return
            }
            
            CocoaLog.debug("--------- 点击Next, 发布或者停止招工信息 -----------\n \(_key) \n -------------------")
            NetworkRequest(RSAPPNetworkAPI.deleteRequirementData(keys: [_original_key]), modelType: RSAPPBaseResponseModel.self) { _, _ in
                NetworkRequest(RSAPPNetworkAPI.SaveRequirementParams(paramsJson: _json, key:_key), modelType: RSAPPBaseResponseModel.self) {[weak self] (res: HandyJSON, res1: SuccessResponse) in
                    sender.stopAnimation()
                    self?.view.makeToast(RSAPPLanguage.localValue("alert_publish_success"), position: .center)
                    tableView.refresh(begin: true)
                }
            }
        }
    }
}

@objc private extension RSAPPPublishViewController {
    func addNewRequirement(sender: UIButton) {
        self.navigationController?.pushViewController(RSAPPBuildRequirementViewController(), animated: true)
    }
    
    func swicthMenu(notification: Notification) {
        guard let _type = notification.object as? RequirementStatus else {
            self.menuView.switchMenuItem(index: .zero)
            return
        }
        
        self.menuView.switchMenuItem(index: _type.rawValue)
    }
}
