//
//  XXPopupWindow.swift
//  XXPopupView
//
//  Created by History on 2017/10/15.
//  Copyright © 2017年 tsing. All rights reserved.
//

import UIKit

class XXPopupWindow: UIWindow, UIGestureRecognizerDelegate {

    var touchWildToHide: Bool
    
    override init(frame: CGRect) {
        self.touchWildToHide = true
        
        super.init(frame: frame)
        
        self.windowLevel = UIWindowLevelStatusBar + 1
        
        let gesture = UITapGestureRecognizer.init(target: self, action: Selector(("actionTap:")))
        gesture.cancelsTouchesInView = false
        gesture.delegate = self
        self.addGestureRecognizer(gesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static let instance: XXPopupWindow = XXPopupWindow(frame: UIScreen.main.bounds)
    
    class func sharedWindow() -> XXPopupWindow {
        return instance
    }
    
    func actionTap(gesture: UITapGestureRecognizer) {
        if self.touchWildToHide && !self.mm_dimBackgroundAnimating {
            for v in (self.attachView()?.mm_dimBackgroundView?.subviews)! {
                if v is UIButton {
                    v.isHidden = true
                }
            }
        }
//        if ( self.touchWildToHide && !self.mm_dimBackgroundAnimating )
//        {
//            for ( UIView *v in [self attachView].mm_dimBackgroundView.subviews )
//            {
//                if ( [v isKindOfClass:[MMPopupView class]] )
//                {
//                    MMPopupView *popupView = (MMPopupView*)v;
//                    [popupView hide];
//                }
//            }
//        }
    }

    func cacheWindow() {
        self.makeKeyAndVisible()
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
        self.attachView()?.mm_dimBackgroundView?.isHidden = true
        self.isHidden = true
    }
    
    func attachView() -> UIView? {
        return self.rootViewController?.view
    }
   
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.attachView()
    }

}
