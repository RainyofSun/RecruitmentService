//
//  APBaseNavigationController.swift
//  ApplicationProject
//
//  Created by Yu Chen  on 2024/11/11.
//

import UIKit

class APBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigationAppearance()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !self.children.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        super.pushViewController(viewController, animated: animated)
    }
    
    deinit {
        deallocPrint()
    }
}

// MARK: Private Methods
private extension APBaseNavigationController {
    func initNavigationAppearance() {
        // Navigation bar
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().tintColor = .white
        
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.hexString("#313131"),
                     NSAttributedString.Key.font: UIFont.boldFont(size: 18)]
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "chevron.backward")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.backward")
        UINavigationBar.appearance().shadowImage = barShadowImage()
    }
    
    func barShadowImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: ScreenWidth, height: 0.5), false, 0)
        let path = UIBezierPath.init(rect: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 0.5))
        UIColor.clear.setFill()// 自定义NavigationBar分割线颜色
        path.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
