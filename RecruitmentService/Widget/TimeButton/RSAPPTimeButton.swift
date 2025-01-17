//
//  RSAPPTimeButton.swift
//  RecruitmentService
//
//  Created by Yu Chen  on 2025/1/17.
//

import UIKit

class RSAPPTimeButton: UIControl {
    
    private lazy var titleLab: UILabel = UILabel.buildLabel(title: RSAPPLanguage.localValue("login_get_code"), titleColor: BLUE_COLOR_1874FF, labFont: UIFont.systemFont(ofSize: 12))
    private var timer: Timer?
    private var _time_num: Int = 60;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderColor = UIColor.hexString("#E5E7EB").cgColor
        self.layer.borderWidth = 1
        
        self.initData()
        self.addSubview(self.titleLab)
        self.titleLab.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT * 2)
            make.horizontalEdges.equalToSuperview().inset(PADDING_UNIT * 3.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocPrint()
    }
    
    private func initData() {
#if DEBUG
        _time_num = 5
#else
        _time_num = 60
#endif
    }
    
    public func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerMethod(time: )), userInfo: nil, repeats: true)
        }
    }
    
    public func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
}

@objc private extension RSAPPTimeButton {
    func timerMethod(time: Timer) {
        DispatchQueue.main.async {
            if self._time_num <= 0 {
                self.timer?.invalidate()
                self.timer = nil
                self.titleLab.text = RSAPPLanguage.localValue("login_get_code")
                self.initData()
            } else {
                self.titleLab.text = "\(self._time_num)s"
                self._time_num -= 1
            }
        }
    }
}
