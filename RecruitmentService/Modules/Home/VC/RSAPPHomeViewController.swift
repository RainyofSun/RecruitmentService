//
//  RSAPPHomeViewController.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

class RSAPPHomeViewController: APBaseViewController, HideNavigationBarProtocol {
    
    private lazy var groupTableView: UITableView = {
        let view = UITableView(frame: CGRectZero, style: UITableView.Style.grouped)
        view.separatorStyle = .none
        return view
    }()
    
    private lazy var bannerView: UIImageView = UIImageView(image: UIImage(named: "home_banner"))
    private lazy var tipView: RSAPPHomeTipView = RSAPPHomeTipView(frame: CGRectZero)
    
    private var question_model_array: [RSAPPHomeQuestionGroupModel] = []
    
    override func buildViewUI() {
        super.buildViewUI()
        
        let group_titles: [String] = [RSAPPLanguage.localValue("home_question_title1"), RSAPPLanguage.localValue("home_question_title2"), RSAPPLanguage.localValue("home_question_title3")]
        let question_array: [String] = [RSAPPLanguage.localValue("home_question_content1"), RSAPPLanguage.localValue("home_question_content2"), RSAPPLanguage.localValue("home_question_content3")]
        
        group_titles.enumerated().forEach { (idx: Int, group: String) in
            let groupModel: RSAPPHomeQuestionGroupModel = RSAPPHomeQuestionGroupModel()
            groupModel.groupTitle = group
            let q_m: RSAPPHomeQuestionModel = RSAPPHomeQuestionModel()
            q_m.content = question_array[idx]
            groupModel.question = [q_m]
            self.question_model_array.append(groupModel)
        }
        
        self.contentView.isHidden = true
        
        self.groupTableView.delegate = self
        self.groupTableView.dataSource = self
        
        self.groupTableView.register(RSAPPHomeQuestionView.self, forCellReuseIdentifier: RSAPPHomeQuestionView.className)
        self.groupTableView.register(RSAPPHomeQuestionHeaderView.self, forHeaderFooterViewReuseIdentifier: RSAPPHomeQuestionHeaderView.className)
        
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: .zero, width: ScreenWidth, height: (ScreenWidth - PADDING_UNIT * 14) * 1.44))
        self.bannerView.frame = CGRect(origin: CGPoint(x: PADDING_UNIT * 7, y: .zero), size: CGSize(width: ScreenWidth - PADDING_UNIT * 14, height: (ScreenWidth - PADDING_UNIT * 14) * 1.44))
        headerView.addSubview(self.bannerView)
        
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: .zero, width: ScreenWidth, height: 100))
        self.tipView.frame = footerView.bounds
        footerView.addSubview(self.tipView)
        
        self.groupTableView.tableHeaderView = headerView
        self.groupTableView.tableFooterView = footerView
        
        self.view.addSubview(self.groupTableView)
       
        self.tipView.gotoClosure = { [weak self] in
            if Global.shared.userData != nil {
                self?.tabBarController?.selectedIndex = 1
            } else {
                let navController = APBaseNavigationController(rootViewController: RSAPPLoginViewController())
                navController.modalPresentationStyle = .fullScreen
                WebPro.enterLoginPage(navController)
            }
        }
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        
        self.groupTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
    }
}

extension RSAPPHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.question_model_array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel: RSAPPHomeQuestionGroupModel = self.question_model_array[section]
        if sectionModel.isExpand {
            return self.question_model_array[section].question?.count ?? 1
        }
        
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _cell = tableView.dequeueReusableCell(withIdentifier: RSAPPHomeQuestionView.className, for: indexPath) as? RSAPPHomeQuestionView else {
            return UITableViewCell()
        }
        
        if let _c = self.question_model_array[indexPath.section].question?.first?.content {
            _cell.setQuestionTitle(content: _c)
        }
        
        return _cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RSAPPHomeQuestionHeaderView.className) as? RSAPPHomeQuestionHeaderView else {
            return nil
        }
        
        header.reloadHeaderTitle(self.question_model_array[section].groupTitle ?? "", isExpand: self.question_model_array[section].isExpand)
        header.clickHeaderClousre = { [weak self] in
            guard let _self = self else {
                return
            }
            _self.question_model_array[section].isExpand = !_self.question_model_array[section].isExpand
            tableView.beginUpdates()
            tableView.reloadSections([section], with: .fade)
            tableView.endUpdates()
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}

@objc private extension RSAPPHomeViewController {
    func clickQuestionItem(sender: RSAPPHomeQuestionView) {
        sender.isSelected = !sender.isSelected
    }
}
