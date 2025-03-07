//
//  RSAPPNotificationEvaluateWorkerView.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/15.
//

import UIKit

class RSAPPNotificationEvaluateWorkerView: UIView {

    private lazy var avatarImgView: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLab: UILabel = UILabel.buildLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        self.titleLab.textAlignment = .left
        
        self.addSubview(self.avatarImgView)
        self.addSubview(self.titleLab)
        
        self.avatarImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 5)
            make.size.equalTo(62)
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT * 5)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.centerY.equalTo(self.avatarImgView)
            make.left.equalTo(self.avatarImgView.snp.right).offset(PADDING_UNIT * 4)
            make.height.equalTo(self.avatarImgView)
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
            paraStyle.alignment = .left
            let nameStr: NSMutableAttributedString = NSMutableAttributedString(string: _name, attributes: [.foregroundColor: BLACK_COLOR_333333, .font: UIFont.boldSystemFont(ofSize: 16), .paragraphStyle: paraStyle])
            nameStr.append(NSAttributedString(string: array.joined(separator: " | "), attributes: [.foregroundColor: UIColor.hexString("#6B7280"), .font: UIFont.systemFont(ofSize: 12)]))
            self.titleLab.attributedText = nameStr
        }
    }
}
