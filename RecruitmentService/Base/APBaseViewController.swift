//
//  APBaseViewController.swift
//  ApplicationProject
//
//  Created by Yu Chen  on 2024/11/11.
//

import UIKit
import FDFullscreenPopGesture
import SnapKit

class APBaseViewController: UIViewController {
    
    private(set) lazy var topView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var logoImgView: UIImageView = {
        let view = UIImageView(image: UIImage(named: ""))
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var appNameLab: UILabel = UILabel.buildLabel(title: Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String, labFont: UIFont(name: "HelveticaNeue-BoldItalic", size: 18))
    
    private lazy var gradientView: RSAPPGradientView = {
        let view = RSAPPGradientView(frame: CGRectZero)
        view.createGradient(gradientColors: [UIColor.hexString("#FFFFFF"), UIColor.hexString("#FBFCFF"), UIColor.hexString("#F1F5FE")], gradientStyle: .leftToRight)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fd_interactivePopDisabled = false
        self.fd_prefersNavigationBarHidden = self.hideNavBar()
        self.buildViewUI()
        self.layoutControlViews()
    }
    
    deinit {
        deallocPrint()
    }
    
    public func hideNavBar() -> Bool {
        return false
    }
    
    public func buildViewUI() {
        self.view.addSubview(self.gradientView)
        self.view.addSubview(self.topView)
        self.topView.addSubview(self.logoImgView)
        self.topView.addSubview(self.appNameLab)
    }
    
    public func layoutControlViews() {
        self.gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.topView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIDevice.xp_statusBarHeight())
            make.horizontalEdges.equalToSuperview()
        }
        
        self.logoImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(PADDING_UNIT * 3)
            make.verticalEdges.equalToSuperview().inset(PADDING_UNIT * 2.5)
            make.size.equalTo(30)
        }
        
        self.appNameLab.snp.makeConstraints { make in
            make.left.equalTo(self.logoImgView.snp.right).offset(PADDING_UNIT * 2)
            make.centerY.equalTo(self.logoImgView)
        }
    }
}
