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
    func mm_truncate(charLength: UInt) -> NSString {
        
        var length = 0;
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

    struct UIViewRuntimeKey {
        static let mm_dimReferenceCount = UnsafeRawPointer.init(bitPattern: "UIViewRuntimeKey".hashValue)
        
        static let mm_dimBackgroundView = UnsafeRawPointer.init(bitPattern: "UIViewRuntimeKey".hashValue)
        static let mm_dimBackgroundBlurEnabled = UnsafeRawPointer.init(bitPattern: "UIViewRuntimeKey".hashValue)
        static let mm_dimBackgroundBlurEffectStyle = UnsafeRawPointer.init(bitPattern: "UIViewRuntimeKey".hashValue)
        
        static let mm_dimBackgroundBlurView = UnsafeRawPointer.init(bitPattern: "UIViewRuntimeKey".hashValue)
        static let mm_dimBackgroundAnimating = UnsafeRawPointer.init(bitPattern: "UIViewRuntimeKey".hashValue)
        static let mm_dimAnimationDuration = UnsafeRawPointer.init(bitPattern: "UIViewRuntimeKey".hashValue)
    }
    
    var mm_dimAnimationDuration: TimeInterval! {
        set {
            objc_setAssociatedObject(self, UIViewRuntimeKey.mm_dimAnimationDuration!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            return objc_getAssociatedObject(self, UIViewRuntimeKey.mm_dimAnimationDuration!) as! TimeInterval
        }
    }
    
    var mm_dimReferenceCount: Int! {
        set {
            objc_setAssociatedObject(self, UIViewRuntimeKey.mm_dimReferenceCount!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            return objc_getAssociatedObject(self, UIViewRuntimeKey.mm_dimReferenceCount!) as! Int
        }
    }
    
    var mm_dimBackgroundAnimating: Bool! {
        set {
            objc_setAssociatedObject(self, UIViewRuntimeKey.mm_dimBackgroundAnimating!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            return objc_getAssociatedObject(self, UIViewRuntimeKey.mm_dimBackgroundAnimating!) as! Bool
        }
    }
    
    var mm_dimBackgroundView: UIView? {
        get {
            var dimView = objc_getAssociatedObject(self, UIViewRuntimeKey.mm_dimBackgroundView!) as? UIView;

            if dimView == nil {
                dimView = UIView.init()
                self.addSubview(dimView!)
                dimView!.snp.makeConstraints { (make) -> Void in
                    make.edges.equalTo(self);
                }
                dimView?.alpha = 0.0
                dimView?.backgroundColor = UIColor.init(xx_hex: 0x0000007F)
                dimView?.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
                objc_setAssociatedObject(self, UIViewRuntimeKey.mm_dimBackgroundView!, dimView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return dimView
        }
    }
    
    var mm_dimBackgroundBlurEnabled: Bool! {
        set {
            objc_setAssociatedObject(self, UIViewRuntimeKey.mm_dimBackgroundBlurEnabled!, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if mm_dimBackgroundBlurEnabled {
                self.mm_dimBackgroundView?.backgroundColor = UIColor.init(xx_hex: 0x00000000)
                self.mm_dimBackgroundBlurView.isHidden = false
            }
            else {
                self.mm_dimBackgroundView?.backgroundColor = UIColor.init(xx_hex: 0x0000007F)
                self.mm_dimBackgroundBlurView.isHidden = true
            }
        }
        get {
            return objc_getAssociatedObject(self, UIViewRuntimeKey.mm_dimBackgroundBlurEnabled!) as! Bool
        }
    }
    
    var mm_dimBackgroundBlurEffectStyle: UIBlurEffectStyle! {
        set {
            objc_setAssociatedObject(self, UIViewRuntimeKey.mm_dimBackgroundBlurEffectStyle!, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if self.mm_dimBackgroundBlurEnabled {
                self.mm_dimBackgroundBlurView.removeFromSuperview()
                self.mm_dimBackgroundBlurView = nil
                let blurView = self.mm_dimBackgroundBlurView
                blurView?.snp.makeConstraints({ (make) -> Void in
                    make.edges.equalTo(self.mm_dimBackgroundView!)
                })
            }
        }
        
        get {
            return objc_getAssociatedObject(self, UIViewRuntimeKey.mm_dimBackgroundBlurEffectStyle!) as! UIBlurEffectStyle
        }
    }
    
    var mm_dimBackgroundBlurView: UIView! {
        set {
            objc_setAssociatedObject(self, UIViewRuntimeKey.mm_dimBackgroundBlurView!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            var blurView = objc_getAssociatedObject(self, UIViewRuntimeKey.mm_dimBackgroundBlurView!) as? UIView
            if blurView == nil {
                blurView = UIView.init()
                let effectView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: self.mm_dimBackgroundBlurEffectStyle))
                blurView?.addSubview(effectView)
                effectView.snp.makeConstraints({ (make) -> Void in
                    make.edges.equalTo(blurView!)
                })
            }
            blurView!.isUserInteractionEnabled = false
            objc_setAssociatedObject(self, UIViewRuntimeKey.mm_dimBackgroundBlurView!, blurView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return blurView;
        }
    }
    
    func mm_hideDimBackground() {
        self.mm_dimReferenceCount = self.mm_dimReferenceCount - 1
        if self.mm_dimReferenceCount > 0 {
            return
        }
        self.mm_dimBackgroundAnimating = true
        
        UIView.animate(withDuration: self.mm_dimAnimationDuration,
                       delay: 0,
                       options: [UIViewAnimationOptions.curveEaseOut, .beginFromCurrentState],
                       animations: { () -> Void in
                        self.mm_dimBackgroundView?.alpha = 0.0
        },
                       completion: { (finished: Bool) -> Void in
                        if finished {
                            self.mm_dimBackgroundAnimating = false
//                            if ( self == [MMPopupWindow sharedWindow].attachView )
//                            {
//                                [MMPopupWindow sharedWindow].hidden = YES;
//                                [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
//                            }
//                            else if ( self == [MMPopupWindow sharedWindow] )
//                            {
//                                self.hidden = YES;
//                                [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
//                            }
                        }
                        })
    }
    
    func mm_showDimBackground() {
        self.mm_dimReferenceCount = self.mm_dimReferenceCount + 1
        if self.mm_dimReferenceCount > 1 {
            return
        }
        self.mm_dimBackgroundView?.isHidden = false
        self.mm_dimBackgroundAnimating = true

        
//        if ( self == [MMPopupWindow sharedWindow].attachView )
//        {
//            [MMPopupWindow sharedWindow].hidden = NO;
//            [[MMPopupWindow sharedWindow] makeKeyAndVisible];
//        }
//        else if ( [self isKindOfClass:[UIWindow class]] )
//        {
//            self.hidden = NO;
//            [(UIWindow*)self makeKeyAndVisible];
//        }
//        else
//        {
//            [self bringSubviewToFront:self.mm_dimBackgroundView];
//        }
//
        UIView.animate(withDuration: self.mm_dimAnimationDuration,
                       delay: 0,
                       options: [UIViewAnimationOptions.curveEaseOut, .beginFromCurrentState],
            animations: { () -> Void in
                self.mm_dimBackgroundView?.alpha = 1.0
        },
            completion: { (finished: Bool) -> Void in
                if finished {
                    self.mm_dimBackgroundAnimating = false
                }
        })
    }
    
    func mm_distributeSpacingHorizontally(views: NSArray) {
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
    
    func mm_distributeSpacingVertically(views: NSArray) {
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
