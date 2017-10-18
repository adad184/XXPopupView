//
//  XXPopupWindow.swift
//  XXPopupView
//
//  Created by History on 2017/10/15.
//  Copyright © 2017年 tsing. All rights reserved.
//

import UIKit

class XXPopupWindow: UIWindow, UIGestureRecognizerDelegate {

    var touchWildToHide: Bool = false
    
    
    open var attachView: UIView {
        return (self.rootViewController?.view!)!
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.windowLevel = UIWindowLevelStatusBar + 1
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(actionTap(gesture:)))
        gesture.cancelsTouchesInView = false
        gesture.delegate = self
        self.addGestureRecognizer(gesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static let instance: XXPopupWindow = {
        
        let instance = XXPopupWindow.init(frame: UIScreen.main.bounds)
        instance.rootViewController = UIViewController()
        
        return instance
    }()
    
    open class func shared() -> XXPopupWindow {
        return instance
    }
    
    @objc func actionTap(gesture: UITapGestureRecognizer) {
        if self.touchWildToHide && !self.xx_dimBackgroundAnimating {
            for v in (self.attachView.xx_dimBackgroundView.subviews) {
                if v is UIButton {
                    v.isHidden = true
                }
            }
        }
        if self.touchWildToHide && !self.xx_dimBackgroundAnimating {
            for v in self.attachView.xx_dimBackgroundView.subviews {
                if v.isKind(of: XXPopupView.self) {
                    (v as! XXPopupView).hide()
                }
            }
        }
    }

    func cacheWindow() {
        self.makeKeyAndVisible()
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
        self.attachView.xx_dimBackgroundView.isHidden = true
        self.isHidden = true
    }
  
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.attachView
    }

}
