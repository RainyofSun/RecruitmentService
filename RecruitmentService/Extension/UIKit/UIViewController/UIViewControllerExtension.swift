//
//  UIViewControllerExtension.swift
//  FastVay
//
//  Created by Yu Chen  on 2024/11/25.
//

import UIKit

// 如果你想使用的optional方法，你必须用@objc标记您的protocol
public protocol ShouldPopDelegate {
    //拦截返回按钮的点击事件
    func currentViewControllerShouldPop() -> Bool
}

@objc extension UIViewController: ShouldPopDelegate {
    public func currentViewControllerShouldPop() -> Bool {
        return true
    }
}

extension UIViewController {
    func topMostController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostController()
        } else if let navigation = self as? UINavigationController {
            return navigation.visibleViewController!.topMostController()
        } else if let tab = self as? UITabBarController {
            return tab.selectedViewController!.topMostController()
        } else {
            return self
        }
    }
}

// MARK: Alert
extension UIViewController {
    func showSystemStyleSettingAlert(content: String, ok: String? = RSAPPLanguage.localValue("alert_sheet_ok"), cancel: String? = RSAPPLanguage.localValue("alert_sheet_cancel")) {
        let alertViewController: UIAlertController = UIAlertController(title: nil, message: content, preferredStyle: UIAlertController.Style.alert)
        let ok: UIAlertAction = UIAlertAction(title: ok, style: UIAlertAction.Style.default) { _ in
            if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
        
        let cancel: UIAlertAction = UIAlertAction(title: cancel, style: UIAlertAction.Style.default) { _ in
            
        }
        
        alertViewController.addAction(ok)
        alertViewController.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(alertViewController, animated: true)
        }
    }
    
    func showTZImagePicker(delegate: TZImagePickerControllerDelegate?) {
        let imagePickerVc = TZImagePickerController(maxImagesCount: 1, columnNumber: 4, delegate: delegate, pushPhotoPickerVc: true)
        imagePickerVc?.allowPickingImage = true
        imagePickerVc?.allowTakePicture = false
        imagePickerVc?.allowTakeVideo = false
        imagePickerVc?.allowPickingGif = false
        imagePickerVc?.allowPickingVideo = false
        imagePickerVc?.allowCrop = true
        imagePickerVc?.cropRect = CGRect(x: 0, y: (ScreenHeight - ScreenWidth) * 0.5, width: ScreenWidth, height: ScreenWidth)
        imagePickerVc?.statusBarStyle = .lightContent
        imagePickerVc?.modalPresentationStyle = .fullScreen
        if let _vc = imagePickerVc {
            self.present(_vc, animated: true)
        }
    }
}
