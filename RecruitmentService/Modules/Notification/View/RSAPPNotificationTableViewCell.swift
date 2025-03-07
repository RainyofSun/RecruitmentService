//
//  RSAPPNotificationTableViewCell.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/15.
//

import UIKit

class RSAPPNotificationTableViewCell: UITableViewCell {

    private lazy var bgView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var avatarImgView: UIImageView = {
        let view = UIImageView(frame: CGRectZero)
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLab: UILabel = UILabel.buildLabel()
    private lazy var arrowImgView: UIImageView = UIImageView(image: UIImage(named: "home_arrow"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.arrowImgView.transform = CGAffineTransform(rotationAngle: -Double.pi * 0.5)
        self.titleLab.textAlignment = .left
        
        self.contentView.addSubview(self.bgView)
        self.bgView.addSubview(self.avatarImgView)
        self.bgView.addSubview(self.titleLab)
        self.bgView.addSubview(self.arrowImgView)
        
        self.bgView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 3.5)
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT)
        }
        
        self.avatarImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 3)
            make.size.equalTo(60)
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT * 3)
        }
        
        self.titleLab.snp.makeConstraints { make in
            make.left.equalTo(self.avatarImgView.snp.right).offset(PADDING_UNIT * 2)
            make.centerY.equalToSuperview()
        }
        
        self.arrowImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-PADDING_UNIT * 3.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    public func reloadCellSource(model: RSAPPNotificationWorkerModel, type: RequirementType) {
        if let _text_url = model.avatar, let _url = URL(string: _text_url) {
            self.avatarImgView.kf.setImage(with: _url, options: [.transition(.fade(0.3))])
        } else {
            self.avatarImgView.image = UIImage(named: "user_default_image")
        }
        
        let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paraStyle.paragraphSpacing = PADDING_UNIT * 2
        let tempStr: NSMutableAttributedString = NSMutableAttributedString(string: RSAPPLanguage.localValue("task_type\(type.rawValue)") + "\n", attributes: [.foregroundColor: BLACK_COLOR_333333, .font: UIFont.systemFont(ofSize: 14), .paragraphStyle: paraStyle])
        tempStr.append(NSAttributedString(string: String(format: RSAPPLanguage.localValue("notification_tip1"), model.name ?? ""), attributes: [.foregroundColor: UIColor.hexString("#6B7280"), .font: UIFont.systemFont(ofSize: 12)]))
        self.titleLab.attributedText = tempStr
    }
}
