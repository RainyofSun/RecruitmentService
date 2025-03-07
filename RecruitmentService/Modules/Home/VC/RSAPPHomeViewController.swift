//
//  RSAPPHomeViewController.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

class RSAPPHomeViewController: APBaseViewController, HideNavigationBarProtocol {

    private lazy var bannerView: UIImageView = UIImageView(image: UIImage(named: "home_banner"))
    private lazy var firstQuestionItem: RSAPPHomeQuestionView = RSAPPHomeQuestionView(frame: CGRectZero)
    private lazy var secondQuestionItem: RSAPPHomeQuestionView = RSAPPHomeQuestionView(frame: CGRectZero)
    private lazy var thirdQuestionItem: RSAPPHomeQuestionView = RSAPPHomeQuestionView(frame: CGRectZero)
    private lazy var tipView: RSAPPHomeTipView = RSAPPHomeTipView(frame: CGRectZero)
    
    override func buildViewUI() {
        super.buildViewUI()
        
        self.firstQuestionItem.setQuestionTitle(title: "home_question_title1", content: "home_question_content1")
        self.secondQuestionItem.setQuestionTitle(title: "home_question_title2", content: "home_question_content2")
        self.thirdQuestionItem.setQuestionTitle(title: "home_question_title3", content: "home_question_content3")
        
        self.firstQuestionItem.addTarget(self, action: #selector(clickQuestionItem(sender: )), for: UIControl.Event.touchUpInside)
        self.secondQuestionItem.addTarget(self, action: #selector(clickQuestionItem(sender: )), for: UIControl.Event.touchUpInside)
        self.thirdQuestionItem.addTarget(self, action: #selector(clickQuestionItem(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentView.addSubview(self.bannerView)
        self.contentView.addSubview(self.firstQuestionItem)
        self.contentView.addSubview(self.secondQuestionItem)
        self.contentView.addSubview(self.thirdQuestionItem)
        self.contentView.addSubview(self.tipView)
        
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
        
        self.bannerView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 7)
            make.top.equalToSuperview().offset(PADDING_UNIT)
            make.size.equalTo(CGSize(width: ScreenWidth - PADDING_UNIT * 14, height: (ScreenWidth - PADDING_UNIT * 14) * 0.44))
        }
        
        self.firstQuestionItem.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 3)
            make.top.equalTo(self.bannerView.snp.bottom).offset(PADDING_UNIT * 4)
            make.width.equalTo(ScreenWidth - PADDING_UNIT * 6)
        }
        
        self.secondQuestionItem.snp.makeConstraints { make in
            make.left.width.equalTo(self.firstQuestionItem)
            make.top.equalTo(self.firstQuestionItem.snp.bottom).offset(PADDING_UNIT * 3.5)
        }
        
        self.thirdQuestionItem.snp.makeConstraints { make in
            make.left.width.equalTo(self.secondQuestionItem)
            make.top.equalTo(self.secondQuestionItem.snp.bottom).offset(PADDING_UNIT * 3.5)
        }
        
        self.tipView.snp.makeConstraints { make in
            make.left.width.equalToSuperview()
            make.top.equalTo(self.thirdQuestionItem.snp.bottom)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 2)
        }
    }
}

@objc private extension RSAPPHomeViewController {
    func clickQuestionItem(sender: RSAPPHomeQuestionView) {
        sender.isSelected = !sender.isSelected
    }
}
