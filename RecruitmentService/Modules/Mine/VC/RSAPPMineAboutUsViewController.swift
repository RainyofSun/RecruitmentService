//
//  RSAPPMineAboutUsViewController.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/15.
//

import UIKit

class RSAPPMineAboutUsViewController: APBaseViewController {

    private lazy var aboutLab: UILabel = UILabel.buildLabel(title: RSAPPLanguage.localValue("mine_about_us_text"), titleColor: UIColor.hexString("#666666"), labFont: UIFont.systemFont(ofSize: 14))
    
    override func buildViewUI() {
        super.buildViewUI()
        self.hideTopView = true
        self.title = RSAPPLanguage.localValue("mine_about_us")
        self.aboutLab.textAlignment = .left
        
        self.contentView.addSubview(self.aboutLab)
    }

    override func layoutControlViews() {
        super.layoutControlViews()
        self.aboutLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT * 6)
            make.left.equalToSuperview().offset(PADDING_UNIT * 3)
            make.width.equalTo(ScreenWidth - PADDING_UNIT * 6)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 6)
        }
    }
}
