//
//  XXAlertView.swift
//  XXPopupView
//
//  Created by Tsing on 2017/10/16.
//  Copyright © 2017年 tsing. All rights reserved.
//

import UIKit

typealias XXPopupInputHandler = (_ text: String) ->Void

class XXAlertView: XXPopupView {

    var maxInputLength: UInt = 0
    fileprivate var titleLabel: UILabel?
    fileprivate var detailLabel: UILabel?
    fileprivate var inputTextField: UITextField?
    fileprivate var buttonView: UIView?
    fileprivate var actionItems: Array<XXPopupItem>?
    fileprivate var inputHandler: XXPopupInputHandler?
    
    
    convenience init(title: String, detail: String) {
        let config = XXAlertViewConfig.globalConfig()
        let items = [XXPopupItem.init(title: config.defaultTextOK, type: .highlighted, handler: nil)]
        self.init(title: title, detail: detail, items: items)
    }
    convenience init(title: String, detail: String, items: Array<XXPopupItem>) {
        self.init(title: title, detail: detail, items: items, inputPlaceholder: nil, inputHandle: nil)
    }
    init(title: String, detail: String, items: Array<XXPopupItem>, inputPlaceholder: String?, inputHandle: XXPopupInputHandler?) {
        super.init(frame: CGRect.zero)
        self.type = .alert
        self.withKeyboard = (inputHandle != nil)
        self.inputHandler = inputHandle
        self.actionItems = items
        
        let config = XXAlertViewConfig.globalConfig()
        self.layer.cornerRadius = CGFloat(config.cornerRadius)
        self.clipsToBounds = true
        self.backgroundColor = config.backgroundColor
        self.layer.borderWidth = 1.0 / UIScreen.main.scale
        self.layer.borderColor = config.splitColor.cgColor
        self.snp.makeConstraints { (make) in
            make.width.equalTo(config.width)
        }
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        var lastAttribute = self.snp.top
        if title.count > 0 {
            self.titleLabel = UILabel()
            self.addSubview(self.titleLabel!)
            self.titleLabel?.snp.makeConstraints({ (make) in
                make.top.equalTo(lastAttribute).offset(config.innerMargin)
                make.left.right.equalTo(self).inset(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin))
            })
            self.titleLabel?.textColor = config.titleColor
            self.titleLabel?.textAlignment = .center
            self.titleLabel?.font = UIFont.systemFont(ofSize: config.titleFontSize)
            self.titleLabel?.numberOfLines = 0
            self.titleLabel?.backgroundColor = self.backgroundColor
            self.titleLabel?.text = title
            lastAttribute = (self.titleLabel?.snp.bottom)!
        }
        if detail.count > 0 {
            self.detailLabel = UILabel()
            self.addSubview(self.detailLabel!)
            self.detailLabel?.snp.makeConstraints({ (make) in
                make.top.equalTo(lastAttribute).offset(5)
                make.left.right.equalTo(self).inset(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin))
            })
            self.detailLabel?.textColor = config.detailColor
            self.detailLabel?.textAlignment = .center
            self.detailLabel?.font = UIFont.systemFont(ofSize: config.detailFontSize)
            self.detailLabel?.numberOfLines = 0
            self.detailLabel?.backgroundColor = self.backgroundColor
            self.detailLabel?.text = detail
            lastAttribute = (self.detailLabel?.snp.bottom)!
        }
        
        if self.inputHandler != nil {
            self.inputTextField = UITextField()
            self.addSubview(self.inputTextField!)
            self.inputTextField?.snp.makeConstraints({ (make) in
                make.top.equalTo(lastAttribute).offset(10)
                make.left.right.equalTo(self).inset(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin))
                make.height.equalTo(40)
            })
            self.inputTextField?.backgroundColor = self.backgroundColor
            self.inputTextField?.layer.borderColor = config.splitColor.cgColor
            self.inputTextField?.layer.borderWidth = 1.0 / UIScreen.main.scale
            self.inputTextField?.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 5, height: 5))
            self.inputTextField?.leftViewMode = .always
            self.inputTextField?.clearButtonMode = .whileEditing
            self.inputTextField?.placeholder = inputPlaceholder
            lastAttribute = (self.inputTextField?.snp.bottom)!
        }
        
        self.buttonView = UIView()
        self.addSubview(self.buttonView!)
        self.buttonView?.snp.makeConstraints({ (make) in
            make.top.equalTo(lastAttribute).offset(config.innerMargin)
            make.left.right.equalTo(self)
        })
        
        var firstButton: UIButton?
        var lastButton: UIButton?
        for i in 0..<items.count {
            let item = items[i]
            let btn = UIButton.xx_button(target: self, action: #selector(actionButton(btn:)))
            self.buttonView?.addSubview(btn)
            btn.tag = i
            btn.snp.makeConstraints({ (make) in
                if items.count <= 2 {
                    make.top.bottom.equalTo(self.buttonView!)
                    make.height.equalTo(config.buttonHeight)
                    if firstButton == nil {
                        firstButton = btn
                        make.left.equalTo((self.buttonView?.snp.left)!).offset(-1.0/UIScreen.main.scale)
                    }
                    else {
                        make.left.equalTo((lastButton?.snp.right)!).offset(-1.0/UIScreen.main.scale)
                        make.width.equalTo(firstButton!);
                    }
                }
                else {
                    make.left.right.equalTo(self.buttonView!)
                    make.height.equalTo(config.buttonHeight)
                    if firstButton == nil {
                        firstButton = btn
                        make.top.equalTo((self.buttonView?.snp.top)!).offset(-1.0/UIScreen.main.scale)
                    }
                    else {
                        make.top.equalTo((lastButton?.snp.bottom)!).offset(-1.0/UIScreen.main.scale)
                        make.width.equalTo(firstButton!);
                    }
                }
                lastButton = btn
            })
            btn.setBackgroundImage(UIImage.xx_image(color: self.backgroundColor!), for: .normal)
            btn.setBackgroundImage(UIImage.xx_image(color: config.itemPressedColor), for: .highlighted)
            btn.setTitle(item.title, for: .normal)
            btn.setTitleColor(item.highlight ? config.itemHighlightColor : config.itemNormalColor, for: .normal)
            btn.layer.borderWidth = 1.0 / UIScreen.main.scale
            btn.layer.borderColor = config.splitColor.cgColor
            btn.titleLabel?.font = (item == items.last) ? UIFont.boldSystemFont(ofSize: config.buttonFontSize) : UIFont.systemFont(ofSize: config.buttonFontSize)
        }
        lastButton?.snp.makeConstraints({ (make) in
            if items.count <= 2 {
                make.right.equalTo((self.buttonView?.snp.right)!).offset(1.0 / UIScreen.main.scale)
            }
            else {
                make.bottom.equalTo((self.buttonView?.snp.bottom)!).offset(1.0 / UIScreen.main.scale)
            }
        })
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo((self.buttonView?.snp.bottom)!)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(notifyTextChange(nti:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    @objc func notifyTextChange(nti: Notification) {
        if self.maxInputLength == 0 {
            return
        }
        if let textField = nti.object as? UITextField {
            guard textField != self.inputTextField else {
                let toBeString = textField.text as NSString?
                let selectedRange = textField.markedTextRange
                let position = textField.position(from: (selectedRange?.start)!, offset: 0)
                if position != nil {
                    if (toBeString?.length)! > self.maxInputLength {
                        textField.text = (toBeString)?.xx_truncate(charLength: self.maxInputLength) as String?
                    }
                }
                return
            }
        }
    }
    
    @objc func actionButton(btn: UIButton?) -> Void {
        let item = self.actionItems![(btn?.tag)!]
        guard item.disabled else {
            if self.withKeyboard && btn?.tag == 1 {
                if (self.inputTextField?.text?.count)! > 0 {
                    self.hide()
                }
            }
            else {
                self.hide()
            }
            if (self.inputHandler != nil) && (btn?.tag)! > 0 {
                self.inputHandler!((self.inputTextField?.text)!)
            }
            else {
                if (item.handler != nil) {
                    item.handler!((btn?.tag)!)
                }
            }
            return
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class XXAlertViewConfig: NSObject {
    var width: CGFloat = 275
    var buttonHeight: CGFloat = 50
    var innerMargin: CGFloat = 25
    var cornerRadius: CGFloat = 5
    
    var titleFontSize: CGFloat = 18
    var detailFontSize: CGFloat = 14
    var buttonFontSize: CGFloat = 17
    
    var backgroundColor: UIColor = UIColor.init(xx_hex: 0xffffffff)
    var titleColor: UIColor = UIColor.init(xx_hex: 0x333333ff)
    var detailColor:UIColor = UIColor.init(xx_hex: 0x333333ff)
    var splitColor:UIColor = UIColor.init(xx_hex: 0xCCCCCCff)
    
    var itemNormalColor: UIColor = UIColor.init(xx_hex: 0x333333ff)
    var itemHighlightColor: UIColor = UIColor.init(xx_hex: 0xE76153ff)
    var itemPressedColor: UIColor = UIColor.init(xx_hex: 0xEFEDE7ff)
    
    var defaultTextOK: String = "好"
    var defaultTextCancel: String = "取消"
    var defaultTextConfirm: String = "确定"
    
    static let instance: XXAlertViewConfig = XXAlertViewConfig()
    
    class func globalConfig() -> XXAlertViewConfig {
        return instance
    }
}
