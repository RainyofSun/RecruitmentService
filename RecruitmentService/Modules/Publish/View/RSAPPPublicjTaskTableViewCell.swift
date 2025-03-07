//
//  RSAPPPublicjTaskTableViewCell.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/10.
//

import UIKit

protocol APPPublicjTaskTableViewCellProtocol: AnyObject {
    func didClickActionButton(sender: RSAPPLoadingButton, model: RSAPPRequirementModel?)
}

class RSAPPPublicjTaskTableViewCell: UITableViewCell {

    weak open var cellDelegate: APPPublicjTaskTableViewCellProtocol?
    
    private lazy var bgView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var contentLab: UILabel = UILabel.buildLabel()
    private lazy var statusLab: UILabel = UILabel.buildLabel(titleColor: UIColor.hexString("#00B578"), labFont: UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium))
    private lazy var actionBtn: RSAPPLoadingButton = RSAPPLoadingButton.buildLoadingButton("", cornerRadius: 4)
    
    private var _cell_model: RSAPPRequirementModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentLab.textAlignment = .left
        
        self.contentView.addSubview(self.bgView)
        self.bgView.addSubview(self.contentLab)
        self.bgView.addSubview(self.statusLab)
        self.bgView.addSubview(self.actionBtn)
        
        self.actionBtn.addTarget(self, action: #selector(clickActionButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.contentLab.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(PADDING_UNIT * 3.5)
            make.width.equalToSuperview().dividedBy(0.5)
            make.height.greaterThanOrEqualTo(70)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 4)
        }
        
        self.statusLab.snp.makeConstraints { make in
            make.top.equalTo(self.contentLab)
            make.right.equalToSuperview().offset(-PADDING_UNIT * 3.5)
        }
        
        self.actionBtn.snp.makeConstraints { make in
            make.right.equalTo(self.statusLab)
            make.top.equalTo(self.statusLab.snp.bottom).offset(PADDING_UNIT * 5.5)
            make.size.equalTo(CGSize(width: 80, height: 32))
        }
        
        self.bgView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 3.5)
            make.verticalEdges.equalToSuperview().offset(PADDING_UNIT)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func reloadCellSource(_ workerModel: RSAPPRequirementModel) {
        self._cell_model = workerModel
        
        let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paraStyle.paragraphSpacing = PADDING_UNIT * 2
        paraStyle.alignment = .left
        let tempstr: NSMutableAttributedString = NSMutableAttributedString(string: String(format: "%@\n", workerModel.requirementName ?? ""), attributes: [.foregroundColor: BLACK_COLOR_333333, .font: UIFont.boldSystemFont(ofSize: 14), .paragraphStyle: paraStyle])
        
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
        
        tempstr.append(NSAttributedString(string: (array.joined(separator: " | ") + "\n"), attributes: [.foregroundColor: UIColor.hexString("#6B7280"), .font: UIFont.systemFont(ofSize: 12), .paragraphStyle: paraStyle]))
        
        if let _address = workerModel.address, let _detail = workerModel.detailAddress {
            tempstr.append(NSAttributedString(string: (_address + " " + _detail), attributes: [.foregroundColor: UIColor.hexString("#6B7280"), .font: UIFont.systemFont(ofSize: 12)]))
        }
        
        self.contentLab.attributedText = tempstr
        
        switch workerModel.status {
        case .Published:
            self.statusLab.text = RSAPPLanguage.localValue("publish_top_menu_item2")
            self.statusLab.textColor = UIColor.hexString("#FF8F1F")
            self.actionBtn.setTitle(RSAPPLanguage.localValue("publish_task_stop"), for: UIControl.State.normal)
            self.actionBtn.isHidden = false
        case .ToBePublished:
            self.statusLab.text = RSAPPLanguage.localValue("publish_top_menu_item3")
            self.actionBtn.setTitle(RSAPPLanguage.localValue("publish_task_start"), for: UIControl.State.normal)
            self.statusLab.textColor = BLACK_COLOR_333333
            self.actionBtn.isHidden = false
        case .RecruitmentEnded:
            self.statusLab.text = RSAPPLanguage.localValue("publish_top_menu_item4")
            self.actionBtn.setTitle(RSAPPLanguage.localValue("publish_task_start"), for: UIControl.State.normal)
            self.statusLab.textColor = UIColor.hexString("#00B578")
            self.actionBtn.isHidden = true
        }
    }
}

@objc private extension RSAPPPublicjTaskTableViewCell {
    func clickActionButton(sender: RSAPPLoadingButton) {
        self.cellDelegate?.didClickActionButton(sender: sender, model: self._cell_model)
    }
}
