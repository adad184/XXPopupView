//
//  XXPopupView.swift
//  XXPopupView
//
//  Created by History on 2017/10/15.
//  Copyright © 2017年 tsing. All rights reserved.
//

import UIKit

enum XXPopupType {
    case Alert
    case Sheet
    case Custom
}

typealias XXPopupBlock = (_ popupView: XXPopupView) ->Void
typealias XXPopupCompletionBlock = (_ popupView: XXPopupView, _ finished: Bool) ->Void

extension Notification.Name {
    
    static let XXPopupViewHideAllNotification = Notification.Name("XXPopupViewHideAllNotification")

}

class XXPopupView: UIView {
    
    var visible: Bool {
        get {
            if self.attachedView != nil {
                return !(self.attachedView!.mm_dimBackgroundView?.isHidden)!
            }
            return false
        }
        set {
            visible = newValue
        }
    }
    var attachedView: UIView?
    var type: XXPopupType
    var withKeyboard: Bool
    var animationDuration: TimeInterval
    var showCompletionBlock: XXPopupCompletionBlock?
    var hideCompletionBlock: XXPopupCompletionBlock?
    var showAnimation: XXPopupBlock?
    var hideAnimation: XXPopupBlock?
    
    override init(frame: CGRect) {
        type = .Alert
        animationDuration = 0.3
        attachedView = XXPopupWindow.sharedWindow().attachView()!
        withKeyboard = false
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: Selector(("notifyHideAll:")), name: .XXPopupViewHideAllNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func notifyHideAll(_ nti: Notification) -> Void {
//        if self is nti.object {
//            self.hide()
//        }
    }
    
    func hide() {
        
    }
    
    func hide(block: XXPopupCompletionBlock) {
        
    }
    
    
    

}
