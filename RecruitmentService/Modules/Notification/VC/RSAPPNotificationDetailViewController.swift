//
//  RSAPPNotificationDetailViewController.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/15.
//

import UIKit

class RSAPPNotificationDetailViewController: APBaseViewController {

    private lazy var checkView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.hexString("#CDE1FD")
        return view
    }()
    
    private lazy var checkLab: UILabel = UILabel.buildLabel()
    private lazy var taskView: RSAPPNotificationRequirementView = RSAPPNotificationRequirementView(frame: CGRectZero)
    private lazy var workerView: RSAPPNotificationWorkerView = RSAPPNotificationWorkerView(frame: CGRectZero)
    private lazy var acceptBtn: UIButton = UIButton.buildLoadingButton(RSAPPLanguage.localValue("notification_accept"), cornerRadius: 4)
    private lazy var refuseBtn: UIButton = UIButton.buildLoadingButton(RSAPPLanguage.localValue("notification_refuse"), cornerRadius: 4)

    private var taskkModel: RSAPPNotificationModel?
    
    init(taskkModel: RSAPPNotificationModel? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.taskkModel = taskkModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func buildViewUI() {
        super.buildViewUI()
        self.hideTopView = true
        self.title = RSAPPLanguage.localValue("notification_detail")
        
        self.checkLab.attributedText = NSAttributedString.attachmentImage("notification_laba", attributeString: String(format: RSAPPLanguage.localValue("notification_check_title"), "\(arc4random()%1000)"), textColor: UIColor.hexString("#3662EC"), textFont: UIFont.systemFont(ofSize: 14))
        self.refuseBtn.backgroundColor = .white
        self.refuseBtn.layer.borderColor = UIColor.hexString("#E5E7EB").cgColor
        self.refuseBtn.layer.borderWidth = 1
        self.refuseBtn.setTitleColor(BLACK_COLOR_333333, for: UIControl.State.normal)
        
        self.acceptBtn.addTarget(self, action: #selector(clickAcceptButton(sender: )), for: UIControl.Event.touchUpInside)
        self.refuseBtn.addTarget(self, action: #selector(clickRefuseButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.taskView.delegate = self
        
        self.contentView.addSubview(self.checkView)
        self.checkView.addSubview(self.checkLab)
        self.contentView.addSubview(self.taskView)
        self.contentView.addSubview(self.workerView)
        self.contentView.addSubview(self.acceptBtn)
        self.contentView.addSubview(self.refuseBtn)
        self.pageRequest()
    }

    override func layoutControlViews() {
        super.layoutControlViews()
        self.checkView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(self.view)
        }
        
        self.checkLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 3)
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT)
        }
        
        self.taskView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 3.5)
            make.top.equalTo(self.checkView.snp.bottom).offset(PADDING_UNIT * 3.5)
            make.width.equalTo(ScreenWidth - PADDING_UNIT * 7)
        }
        
        self.workerView.snp.makeConstraints { make in
            make.top.equalTo(self.taskView.snp.bottom).offset(PADDING_UNIT * 2.5)
            make.horizontalEdges.equalTo(self.taskView)
        }
        
        self.acceptBtn.snp.makeConstraints { make in
            make.top.equalTo(self.workerView.snp.bottom).offset(PADDING_UNIT * 4.5)
            make.horizontalEdges.equalTo(self.workerView)
            make.height.equalTo(47)
        }
        
        self.refuseBtn.snp.makeConstraints { make in
            make.top.equalTo(self.acceptBtn.snp.bottom).offset(PADDING_UNIT * 2.5)
            make.horizontalEdges.height.equalTo(self.acceptBtn)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 4)
        }
    }
    
    override func pageRequest() {
        super.pageRequest()
        if let _model = self.taskkModel?.task {
            self.taskView.reloadRequirementDetail(_model)
        }
        
        if let _worker = self.taskkModel?.worker {
            self.workerView.reloadWorker(workerModel: _worker)
        }
    }
}

extension RSAPPNotificationDetailViewController: APPNotificationRequirementProtocol {
    func checkRequirementDetail() {
        self.navigationController?.pushViewController(RSAPPRequirementDetailVC(status: RequirementStatus.Published, requirementModel: self.taskkModel?.task, imageArray: nil), animated: true)
    }
}

@objc private extension RSAPPNotificationDetailViewController {
    func clickAcceptButton(sender: UIButton) {
        RSAPPBaseAlertView.showAlertView(content: RSAPPLanguage.localValue("notification_tip2"), rightButtonTitle: RSAPPLanguage.localValue("notification_accept"), superView: self.view).notificationCodeLayout().codeConfirmClosure = { [weak self] (isConfirm: Bool, code: String) in
            if isConfirm {
                self?.navigationController?.pushViewController(RSAPPNotificationEvaluateViewController(taskModel: self?.taskkModel), animated: true)
            }
        }
    }
    
    func clickRefuseButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
