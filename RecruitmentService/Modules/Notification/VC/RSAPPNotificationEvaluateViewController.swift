//
//  RSAPPNotificationEvaluateViewController.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/2/15.
//

import UIKit

class RSAPPNotificationEvaluateViewController: APBaseViewController {

    private var taskModel: RSAPPNotificationModel?
    private lazy var evaluateWorkerView: RSAPPNotificationEvaluateWorkerView = RSAPPNotificationEvaluateWorkerView(frame: CGRectZero)
    private lazy var evaluateView: RSAPPNotificationEvaluationView = RSAPPNotificationEvaluationView(frame: CGRectZero)
    
    private lazy var nextBtn: RSAPPLoadingButton = RSAPPLoadingButton.buildLoadingButton(RSAPPLanguage.localValue("notification_evalute_tip7"), cornerRadius: 4)
    
    init(taskModel: RSAPPNotificationModel? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.taskModel = taskModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func buildViewUI() {
        super.buildViewUI()
        self.hideTopView = true
        self.title = RSAPPLanguage.localValue("notification_evalute")
        
        self.nextBtn.addTarget(self, action: #selector(clickEvaluteButton(sender: )), for: UIControl.Event.touchUpInside)
        
        self.evaluateView.superController = self
        
        self.contentView.addSubview(self.evaluateWorkerView)
        self.contentView.addSubview(self.evaluateView)
        self.contentView.addSubview(self.nextBtn)
        
        self.pageRequest()
    }
    
    override func layoutControlViews() {
        super.layoutControlViews()
        self.evaluateWorkerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(PADDING_UNIT * 2)
            make.left.equalToSuperview().offset(PADDING_UNIT * 3)
            make.width.equalTo(ScreenWidth - PADDING_UNIT * 6)
        }
        
        self.evaluateView.snp.makeConstraints { make in
            make.top.equalTo(self.evaluateWorkerView.snp.bottom).offset(PADDING_UNIT * 2)
            make.left.width.equalToSuperview()
        }
        
        self.nextBtn.snp.makeConstraints { make in
            make.top.equalTo(self.evaluateView.snp.bottom).offset(PADDING_UNIT * 17)
            make.horizontalEdges.equalTo(self.view).inset(PADDING_UNIT * 3)
            make.bottom.equalToSuperview().offset(-PADDING_UNIT * 4)
            make.height.equalTo(47)
        }
    }
    
    override func pageRequest() {
        super.pageRequest()
        if let _model = self.taskModel?.worker {
            self.evaluateWorkerView.reloadWorker(workerModel: _model)
        }
    }
}

@objc private extension RSAPPNotificationEvaluateViewController {
    func clickEvaluteButton(sender: UIButton) {
        guard let _ = self.evaluateView.evaluateText else {
            return
        }
        
        RSAPPBaseAlertView.showAlertView(content: RSAPPLanguage.localValue("notification_evalute_tip8"), rightButtonTitle: RSAPPLanguage.localValue("alert_btn_ok"), superView: self.view).evaluteLayout().closeClosure = {[weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}
