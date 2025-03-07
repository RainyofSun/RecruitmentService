//
//  RSAPPEmptyView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

class RSAPPEmptyView: UIView {

    open var gotoPublishClosure:(() -> Void)?
    
    private lazy var emptyImgView: UIImageView = UIImageView(image: UIImage(named: "list_empty"))
    private lazy var titleLab: UILabel = UILabel.buildLabel(title: RSAPPLanguage.localValue("publish_empty_title"), titleColor: GRAY_COLOR_999999, labFont: UIFont.boldSystemFont(ofSize: 24))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.emptyImgView)
        self.addSubview(self.titleLab)
        
        self.titleLab.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(35)
        }
        
        self.emptyImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.titleLab.snp.top).offset(-PADDING_UNIT * 2)
            make.size.equalTo(240)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
}
