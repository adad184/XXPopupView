//
//  XXPopupView.swift
//  XXPopupView
//
//  Created by History on 2017/10/15.
//  Copyright © 2017年 tsing. All rights reserved.
//

import UIKit

enum XXPopupType {
    case alert
    case sheet
    case custom
}

typealias XXPopupBlock = (_ popupView: XXPopupView) ->Void
typealias XXPopupCompletionBlock = (_ popupView: XXPopupView, _ finished: Bool) ->Void

extension Notification.Name {
    
    static let XXPopupViewHideAllNotification = Notification.Name("XXPopupViewHideAllNotification")

}

class XXPopupView: UIView {
    
    var visible: Bool {
        return self.attachedView.xx_dimBackgroundView.isHidden
    }
    var attachedView: UIView = XXPopupWindow.shared().attachView
    var type: XXPopupType = .alert {
        didSet {
            switch type {
            case .alert:
                self.showAnimation = alertShowAnimation()
                self.hideAnimation = alertHideAnimation()
            case .sheet:
                self.showAnimation = sheetShowAnimation()
                self.hideAnimation = sheetHideAnimation()
            case .custom:
                self.showAnimation = customShowAnimation()
                self.hideAnimation = customHideAnimation()
            }
        }
    }
    var withKeyboard: Bool = false
    var animationDuration: TimeInterval = 0.3 {
        didSet {
            attachedView.xx_dimAnimationDuration = animationDuration
        }
    }
    var showCompletionBlock: XXPopupCompletionBlock?
    var hideCompletionBlock: XXPopupCompletionBlock?
    var showAnimation: XXPopupBlock?
    var hideAnimation: XXPopupBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyHideAll(_:)), name: .XXPopupViewHideAllNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func notifyHideAll(_ nti: Notification) -> Void {
        guard let _ = nti.object as? XXPopupView else {
            return
        }
        hide()
    }
    
    class func hideAll() {
        NotificationCenter.default.post(name: .XXPopupViewHideAllNotification, object: XXPopupView.self)
    }
    
    func show() {
        self.show(block: nil)
    }
    func show(block: XXPopupCompletionBlock?) -> Void {
        self.showCompletionBlock = block
        self.attachedView.xx_showDimBackground()
        if let showAnimation = self.showAnimation {
            showAnimation(self)
        }
        if self.withKeyboard {
            self.showKeyboard()
        }
    }
    func hide() {
        self.hide(block: nil)
    }
    
    func hide(block: XXPopupCompletionBlock?) {
        self.hideCompletionBlock = block
        self.attachedView.xx_hideDimBackground()
        if self.withKeyboard {
            self.hideKeyboard()
        }
        if let hideAnimation = self.hideAnimation {
            hideAnimation(self)
        }
    }
    
    func alertShowAnimation() -> XXPopupBlock {
        let block: (XXPopupView) -> Void = {
            [weak self] (popupView: XXPopupView) in
            
            if self?.superview == nil {
                self?.attachedView.xx_dimBackgroundView.addSubview(self!)
                self?.snp.makeConstraints({ (make) in
                    make.center.equalTo((self?.attachedView)!).offset((self?.withKeyboard)! ? -216 / 2 : 0)
                })
                
                self?.superview?.layoutIfNeeded()
            }
            
            self?.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.2)
            self?.alpha = 0.0
            
            UIView.animate(withDuration: (self?.animationDuration)!,
                           delay: 0.0,
                           options: [.curveEaseOut, .beginFromCurrentState],
                           animations: {
                            
                            self?.layer.transform = CATransform3DIdentity
                            self?.alpha = 1.0
                            
            }, completion: { (finished) in
                
                if let complete = self?.showCompletionBlock {
                    complete(self!, finished)
                }
                
            })
            
        }
        
        return block
    }
    
    func alertHideAnimation() -> XXPopupBlock {
        let block: (XXPopupView) -> Void = {
            [weak self] (popupView: XXPopupView) in
            
            UIView.animate(withDuration: (self?.animationDuration)!,
                           delay: 0.0,
                           options: [.curveEaseOut, .beginFromCurrentState],
                           animations: {
                            self?.alpha = 0.0
                            
            }, completion: { (finished) in
                if finished {
                    self?.removeFromSuperview()
                }
                if let complete = self?.hideCompletionBlock {
                    complete(self!, finished)
                }
            })
            
        }
        
        return block
    }
    
    func sheetShowAnimation() -> XXPopupBlock {
        let block: (XXPopupView) -> Void = {
            [weak self] (popupView: XXPopupView) in
            
            if self?.superview == nil {
                self?.attachedView.xx_dimBackgroundView.addSubview(self!)
                self?.snp.makeConstraints({ (make) in
                    make.centerX.equalTo((self?.attachedView)!)
                    make.bottom.equalTo((self?.attachedView.snp.bottom)!).offset((self?.attachedView.frame.size.height)!)
                })
                self?.superview?.layoutIfNeeded()
            }
            
            UIView.animate(withDuration: (self?.animationDuration)!,
                           delay: 0.0,
                           options: [.curveEaseOut, .beginFromCurrentState],
                           animations: {
                            self?.snp.makeConstraints({ (make) in
                                make.bottom.equalTo((self?.attachedView.snp.bottom)!).offset(0)
                            })
                            self?.superview?.layoutIfNeeded()
                            
            },
                           completion: { (finished) in
                            
                            if let complete = self?.showCompletionBlock {
                                complete(self!, finished)
                            }
                            
            })
            
        }
        return block
    }
    func sheetHideAnimation() -> XXPopupBlock {
        let block: (XXPopupView) -> Void = {
            [weak self] (popupView: XXPopupView) in
            
            UIView.animate(withDuration: (self?.animationDuration)!,
                           delay: 0.0,
                           options: [.curveEaseOut, .beginFromCurrentState],
                           animations: {
                           
                            self?.snp.updateConstraints({ (make) in
                                make.bottom.equalTo((self?.attachedView.snp.bottom)!).offset((self?.attachedView.frame.size.height)!)
                            })
                            self?.superview?.layoutIfNeeded()
            },
                           completion: { (finished) in
                            if finished {
                                self?.removeFromSuperview()
                            }
                            if let complete = self?.hideCompletionBlock {
                                complete(self!, finished)
                            }
            })
            
        }
        
        return block
    }
    
    func customShowAnimation() -> XXPopupBlock {
        let block: (XXPopupView) -> Void = {
            [weak self] (popupView: XXPopupView) in
            if self?.superview == nil {
                self?.attachedView.xx_dimBackgroundView.addSubview(self!)
                self?.snp.updateConstraints({ (make) in
                    make.centerX.equalTo((self?.attachedView)!)
                    make.centerY.equalTo((self?.attachedView)!).offset((self?.attachedView.bounds.size.height)!)
                })
                self?.superview?.layoutIfNeeded()
            }

            UIView.animate(withDuration: (self?.animationDuration)!,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 1.5,
                           options: [.curveEaseOut, .beginFromCurrentState],
                           animations: {
                            self?.snp.updateConstraints({ (make) in
                                make.centerX.equalTo((self?.attachedView)!).offset(0)
                                make.centerY.equalTo((self?.attachedView)!).offset((self?.withKeyboard)! ? -216 / 2 : 0)
                            })
                            self?.superview?.layoutIfNeeded()
            },
                           completion: { (finished) in
                            if let completion = self?.showCompletionBlock {
                                completion(self!, finished)
                            }
                            
            })
        }
        return block
    }
    func customHideAnimation() -> XXPopupBlock {
        let block: (XXPopupView) -> Void = {
            [weak self] (popupView: XXPopupView) in
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: [.curveEaseOut, .beginFromCurrentState],
                           animations: {
                            
                            self?.snp.updateConstraints({ (make) in
                                make.centerX.equalTo((self?.attachedView)!).offset(0)
                                make.centerY.equalTo((self?.attachedView)!).offset((self?.attachedView.bounds.size.height)!)
                            })
                            self?.superview?.layoutIfNeeded()
            },
                           completion: { (finished) in
                            if finished {
                                self?.removeFromSuperview()
                            }
                            if let complete = self?.hideCompletionBlock {
                                complete(self!, finished)
                            }
            })
        }
        return block
    }
    
    func showKeyboard() {
        
    }
    func hideKeyboard() {
        
    }
}
