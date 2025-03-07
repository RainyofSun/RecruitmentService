//
//  RSAPPNotificationWorkerView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/15.
//

import UIKit

class RSAPPNotificationWorkerView: UIView {

    private lazy var avatarImgView: UIImageView = UIImageView(frame: CGRectZero)
    private lazy var titleLab: UILabel = UILabel.buildLabel()
    private lazy var desLab: UILabel = UILabel.buildLabel(title: RSAPPLanguage.localValue("notification_worker_des"), titleColor: BLACK_COLOR_333333, labFont: UIFont.boldSystemFont(ofSize: 16))
    
    private lazy var desContentLab: UILabel = UILabel.buildLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.backgroundColor = .white
        
        self.desLab.textAlignment = .left
        self.desContentLab.textAlignment = .left
        
        self.addSubview(self.avatarImgView)
        self.addSubview(self.titleLab)
        self.addSubview(self.desLab)
        self.addSubview(self.desContentLab)
        
        self.avatarImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(PADDING_UNIT * 5)
            make.size.equalTo(80)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 5)
            make.top.equalTo(self.avatarImgView.snp.bottom).offset(PADDING_UNIT * 2.5)
        }
        
        self.desLab.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.titleLab)
            make.top.equalTo(self.titleLab.snp.bottom).offset(PADDING_UNIT * 5)
        }
        
        self.desContentLab.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.desLab)
            make.top.equalTo(self.desLab.snp.bottom).offset(PADDING_UNIT * 2)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 9)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadWorker(workerModel: RSAPPNotificationWorkerModel) {        
        if let _text_url = workerModel.avatar, let _url = URL(string: _text_url) {
            self.avatarImgView.kf.setImage(with: _url, options: [.transition(.fade(0.3))])
        } else {
            self.avatarImgView.image = UIImage(named: "user_default_image")
        }
        
        if var _name = workerModel.name {
            var array: [String] = []
            if let _sex = workerModel.sex {
                array.append(_sex)
            }
            
            if let _age = workerModel.age {
                array.append(_age)
            }
            
            if let _education = workerModel.education {
                array.append(_education)
            }
            
            if let _experience = workerModel.experience {
                array.append(_experience)
            }
            
            if !array.isEmpty {
                _name += "\n"
            }
            
            let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paraStyle.paragraphSpacing = PADDING_UNIT * 2
            paraStyle.alignment = .center
            let nameStr: NSMutableAttributedString = NSMutableAttributedString(string: _name, attributes: [.foregroundColor: BLACK_COLOR_333333, .font: UIFont.boldSystemFont(ofSize: 16), .paragraphStyle: paraStyle])
            nameStr.append(NSAttributedString(string: array.joined(separator: " | "), attributes: [.foregroundColor: UIColor.hexString("#6B7280"), .font: UIFont.systemFont(ofSize: 12)]))
            self.titleLab.attributedText = nameStr
        }
        
        if let _intro = workerModel.intro {
            self.desContentLab.attributedText = NSAttributedString(string: _intro, attributes: [.foregroundColor: UIColor.hexString("#6B7280"), .font: UIFont.systemFont(ofSize: 12)])
        }
    }
}
