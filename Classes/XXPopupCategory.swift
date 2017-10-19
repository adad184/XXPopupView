//
//  XXPopupCategory.swift
//  XXPopupView
//
//  Created by History on 2017/10/15.
//  Copyright © 2017年 tsing. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

extension UIColor {
    convenience init(xx_hex: UInt) {
        let r = CGFloat((xx_hex & 0xff000000) >> 24)
        let g = CGFloat((xx_hex & 0x00ff0000) >> 16)
        let b = CGFloat((xx_hex & 0x0000ff00) >> 8)
        let a = CGFloat((xx_hex & 0x000000ff))
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a/255.0)
    }
}

extension UIButton {
    open class func xx_button(target: Any, action:Selector) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.isExclusiveTouch = true
        return btn
    }
}

extension UIImage {
    open func xx_stretched() -> UIImage {
        let size = self.size
        let insets = UIEdgeInsetsMake(CGFloat(truncf(Float(size.height-1))/2),
                                      CGFloat(truncf(Float(size.width-1))/2),
                                      CGFloat(truncf(Float(size.height-1))/2),
                                      CGFloat(truncf(Float(size.width-1))/2))
        return self.resizableImage(withCapInsets: insets)
    }
    
    open class func xx_image(color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect.init(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext();
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image?.xx_stretched()
    }
    
    class func xx_image(color: UIColor) -> UIImage? {
        return self.xx_image(color: color, size: CGSize.init(width: 4.0, height: 4.0))
    }
}

extension NSString {
    func xx_truncate(charLength: UInt) -> NSString {
        
        var length = 0;
//        self.enumerateSubstrings(in: NSMakeRange(0, self.count),
//                                 options: .byComposedCharacterSequences) { (substring, substringRange, enclosingRange, stop) in
//                                    if length+substringRange.length > charLength {
//                                        stop.pointee = true
//                                        return
//                                    }
//                                    length += substringRange.length
//
//        }
//        return self.substring(to: length) as String
        self.enumerateSubstrings(in: NSMakeRange(0, self.length),
                                 options: .byComposedCharacterSequences,
                                 using: {
            (substring, substringRange, enclosingRange, stop) -> () in
                                    if length+substringRange.length > charLength {
                                        stop.pointee = true
                                        return
                                    }
                                    length += substringRange.length
        })
        return self.substring(to: length) as NSString
    }
}

extension UIView {
    
    private struct UIViewRuntimeKey {
        static var xx_dimReferenceCount = "xx_dimReferenceCount"
        
        static var xx_dimBackgroundView = "xx_dimBackgroundView"
        static var xx_dimBackgroundBlurEnabled = "xx_dimBackgroundBlurEnabled"
        static var xx_dimBackgroundBlurEffectStyle = "xx_dimBackgroundBlurEffectStyle"
        
        static var xx_dimBackgroundBlurView = "xx_dimBackgroundBlurView"
        static var xx_dimBackgroundAnimating = "xx_dimBackgroundAnimating"
        static var xx_dimAnimationDuration = "xx_dimAnimationDuration"
    }
    
    var xx_dimAnimationDuration: TimeInterval! {
        set {
            objc_setAssociatedObject(self, UIViewRuntimeKey.xx_dimAnimationDuration, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            guard let duration = objc_getAssociatedObject(self, &UIViewRuntimeKey.xx_dimAnimationDuration) as? TimeInterval else {
                
                let initialDuration: TimeInterval = 0.3
                
                objc_setAssociatedObject(self, &UIViewRuntimeKey.xx_dimAnimationDuration, initialDuration, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return initialDuration
            }
            return duration
        }
    }
    
    var xx_dimReferenceCount: Int! {
        
        set {
            objc_setAssociatedObject(self, UIViewRuntimeKey.xx_dimReferenceCount, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            guard let count = objc_getAssociatedObject(self, &UIViewRuntimeKey.xx_dimReferenceCount) as? Int else {
                
                let initialCount: Int = 0
                
                objc_setAssociatedObject(self, &UIViewRuntimeKey.xx_dimReferenceCount, initialCount, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return initialCount
            }
            return count
        }
    }
    
    var xx_dimBackgroundAnimating: Bool! {
        set {
            objc_setAssociatedObject(self, &UIViewRuntimeKey.xx_dimBackgroundAnimating, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            guard let animating = objc_getAssociatedObject(self, &UIViewRuntimeKey.xx_dimBackgroundAnimating) as? Bool else {
                
                let initialAnimating: Bool = true
                
                objc_setAssociatedObject(self, &UIViewRuntimeKey.xx_dimBackgroundAnimating, initialAnimating, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                return initialAnimating
            }
            return animating
        }
    }
    
    var xx_dimBackgroundView: UIView {
        get {
            guard let dimView = objc_getAssociatedObject(self, &UIViewRuntimeKey.xx_dimBackgroundView) as? UIView else {
                let dimView = UIView()
                self.addSubview(dimView)
                dimView.snp.makeConstraints { (make) -> Void in
                    make.edges.equalTo(self);
                }
                dimView.alpha = 0.0
                dimView.backgroundColor = UIColor.init(xx_hex: 0x0000007F)
                dimView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
                objc_setAssociatedObject(self, &UIViewRuntimeKey.xx_dimBackgroundView, dimView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return dimView
            }
            return dimView
        }
    }
    
    var xx_dimBackgroundBlurEnabled: Bool! {
        set {
            objc_setAssociatedObject(self, &UIViewRuntimeKey.xx_dimBackgroundBlurEnabled, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if xx_dimBackgroundBlurEnabled {
                self.xx_dimBackgroundView.backgroundColor = UIColor.init(xx_hex: 0x00000000)
                self.xx_dimBackgroundBlurView.isHidden = false
            }
            else {
                self.xx_dimBackgroundView.backgroundColor = UIColor.init(xx_hex: 0x0000007F)
                self.xx_dimBackgroundBlurView.isHidden = true
            }
        }
        get {
            guard let enabled = objc_getAssociatedObject(self, &UIViewRuntimeKey.xx_dimBackgroundBlurEnabled) as? Bool  else {
                let initialEnabled = true
                objc_setAssociatedObject(self, &UIViewRuntimeKey.xx_dimBackgroundBlurEnabled, initialEnabled, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return initialEnabled
            }
            return enabled
        }
    }
    
    var xx_dimBackgroundBlurEffectStyle: UIBlurEffectStyle! {
        set {
            objc_setAssociatedObject(self, &UIViewRuntimeKey.xx_dimBackgroundBlurEffectStyle, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if self.xx_dimBackgroundBlurEnabled {
                self.xx_dimBackgroundBlurView.removeFromSuperview()
                self.xx_dimBackgroundBlurView = nil
                let blurView = self.xx_dimBackgroundBlurView
                blurView?.snp.makeConstraints({ (make) -> Void in
                    make.edges.equalTo(self.xx_dimBackgroundView)
                })
            }
        }
        
        get {
            guard let style = objc_getAssociatedObject(self, &UIViewRuntimeKey.xx_dimBackgroundBlurEffectStyle) as? UIBlurEffectStyle  else {
                let initialStyle: UIBlurEffectStyle = .light
                objc_setAssociatedObject(self, &UIViewRuntimeKey.xx_dimBackgroundBlurEffectStyle, initialStyle, .OBJC_ASSOCIATION_ASSIGN)
                return initialStyle
            }
            return style
        }
    }
    
    var xx_dimBackgroundBlurView: UIView! {
        set {
            objc_setAssociatedObject(self, &UIViewRuntimeKey.xx_dimBackgroundBlurView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            guard let blurView = objc_getAssociatedObject(self, &UIViewRuntimeKey.xx_dimBackgroundBlurView) as? UIView else {
                let blurView = UIView()
                let effectView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: self.xx_dimBackgroundBlurEffectStyle))
                blurView.addSubview(effectView)
                effectView.snp.makeConstraints({ (make) -> Void in
                    make.edges.equalTo(blurView)
                })
                blurView.isUserInteractionEnabled = false
                objc_setAssociatedObject(self, &UIViewRuntimeKey.xx_dimBackgroundBlurView, blurView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return blurView
            }
            return blurView;
        }
    }
    
    func xx_hideDimBackground() {
        self.xx_dimReferenceCount = self.xx_dimReferenceCount - 1
        if self.xx_dimReferenceCount > 0 {
            return
        }
        self.xx_dimBackgroundAnimating = true
        
        UIView.animate(withDuration: self.xx_dimAnimationDuration,
                       delay: 0,
                       options: [UIViewAnimationOptions.curveEaseOut, .beginFromCurrentState],
                       animations: { () -> Void in
                        self.xx_dimBackgroundView.alpha = 0.0
        },
                       completion: { (finished: Bool) -> Void in
                        if finished {
                            self.xx_dimBackgroundAnimating = false
                            if self == XXPopupWindow.shared().attachView {
                                XXPopupWindow.shared().isHidden = true
                                UIApplication.shared.delegate?.window??.makeKey()
                            }
                            else if self == XXPopupWindow.shared() {
                                self.isHidden = true
                                UIApplication.shared.delegate?.window??.makeKey()
                            }
                        }
        })
    }
    
    func xx_showDimBackground() {
        self.xx_dimReferenceCount = self.xx_dimReferenceCount + 1
        if self.xx_dimReferenceCount > 1 {
            return
        }
        self.xx_dimBackgroundView.isHidden = false
        self.xx_dimBackgroundAnimating = true

        if self == XXPopupWindow.shared().attachView {
            XXPopupWindow.shared().isHidden = false
            XXPopupWindow.shared().makeKeyAndVisible()
        }
        else if self.isKind(of: UIWindow.self) {
            self.isHidden = false
            (self as! UIWindow).makeKeyAndVisible()
        }
        else {
            self.bringSubview(toFront: self.xx_dimBackgroundView)
        }

        UIView.animate(withDuration: self.xx_dimAnimationDuration,
                       delay: 0,
                       options: [UIViewAnimationOptions.curveEaseOut, .beginFromCurrentState],
            animations: { () -> Void in
                self.xx_dimBackgroundView.alpha = 1.0
        },
            completion: { (finished: Bool) -> Void in
                if finished {
                    self.xx_dimBackgroundAnimating = false
                }
        })
    }
    
    func xx_distributeSpacingHorizontally(views: NSArray) {
        var spaces = Array<UIView>.init()
        for _ in 0...views.count+1 {
            let v = UIView.init()
            spaces.append(v)
            self.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.width.equalTo(v.snp.height)
            })
        }
        let v0 = spaces[0]
        v0.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.centerY.equalTo((views[0] as! UIView).snp.centerY)
        }
        var lastSpace = v0
        for i in 0...views.count {
            let obj = views[i] as! UIView
            let space = spaces[i+1]
            obj.snp.makeConstraints({ (make) in
                make.left.equalTo(lastSpace.snp.right)
            })
            lastSpace = space
        }

        lastSpace.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right)
        }
    }
    
    func xx_distributeSpacingVertically(views: NSArray) {
        var spaces = Array<UIView>.init()
        for _ in 0...views.count+1 {
            let v = UIView.init()
            spaces.append(v)
            self.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.width.equalTo(v.snp.height)
            })
        }
        let v0 = spaces[0]
        v0.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.centerX.equalTo((views[0] as! UIView).snp.centerX)
        }
        var lastSpace = v0
        for i in 0...views.count {
            let obj = views[i] as! UIView
            let space = spaces[i+1]
            obj.snp.makeConstraints({ (make) in
                make.top.equalTo(lastSpace.snp.bottom)
            })
            space.snp.makeConstraints({ (make) in
                make.top.equalTo(obj.snp.bottom)
                make.centerX.equalTo(obj.snp.centerX)
                make.height.equalTo(v0)
            })
            lastSpace = space
        }
        
        lastSpace.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}
