//
//  RSAPPHomeQuestionView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/16.
//

import UIKit

class RSAPPHomeQuestionView: UITableViewCell {
    
    private lazy var contentLab: UILabel = {
        let view = UILabel.buildLabel()
        view.textAlignment = .left
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(self.contentLab)
        
        self.contentLab.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(PADDING_UNIT * 3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func setQuestionTitle(content: String) {
        self.contentLab.text = String(format: RSAPPLanguage.localValue(content), UIDevice.appName())
    }
}
