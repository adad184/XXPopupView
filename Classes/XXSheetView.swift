//
//  XXSheetView.swift
//  XXPopupView
//
//  Created by Tsing on 2017/10/18.
//  Copyright © 2017年 tsing. All rights reserved.
//

import UIKit

class XXSheetView: XXPopupView {

    fileprivate var titleView: UIView?
    fileprivate var titleLabel: UILabel?
    fileprivate var buttonView: UIView?
    fileprivate var cancelButton: UIButton?
    fileprivate var actionItems: Array<XXPopupItem>?

    init(title: String, items: Array<XXPopupItem>) {
        super.init(frame: CGRect.zero)
        self.type = .sheet
        self.actionItems = items
        
        let config = XXSheetViewConfig.globalConfig()
        
        self.backgroundColor = config.splitColor
        
        self.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.size.width)
        }
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        
        var lastAttribute = self.snp.top
        if title.count > 0 {
            self.titleView = UIView()
            self.addSubview(self.titleView!)
            self.titleView?.snp.makeConstraints({ (make) in
                make.left.right.top.equalTo(self)
            })
            self.titleView?.backgroundColor = config.backgroundColor
            
            self.titleLabel = UILabel()
            self.titleView?.addSubview(self.titleLabel!)
            self.titleLabel?.snp.makeConstraints({ (make) in
                make.edges.equalTo(self.titleView!).inset(UIEdgeInsetsMake(config.innerMargin, config.innerMargin, config.innerMargin, config.innerMargin))
            })
            self.titleLabel?.textColor = config.titleColor
            self.titleLabel?.font = UIFont.systemFont(ofSize: config.titleFontSize)
            self.titleLabel?.textAlignment = .center
            self.titleLabel?.numberOfLines = 0
            self.titleLabel?.text = title
            lastAttribute = (self.titleView?.snp.bottom)!
        }
        
        self.buttonView = UIView()
        self.addSubview(self.buttonView!)
        self.buttonView?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(lastAttribute)
        })
        
        var firstButton: UIButton?
        var lastButton: UIButton?
        for i in 0..<items.count {
            let item = items[i]
            let btn = UIButton.xx_button(target: self, action: #selector(actionButton(btn:)))
            self.buttonView?.addSubview(btn)
            btn.tag = i
            btn.snp.makeConstraints({ (make) in
                make.left.right.equalTo(self.buttonView!).inset(UIEdgeInsetsMake(0, -1.0/UIScreen.main.scale, 0, -1.0/UIScreen.main.scale))
                make.height.equalTo(config.buttonHeight)
                if firstButton == nil {
                    firstButton = btn
                    make.top.equalTo((self.buttonView?.snp.top)!).offset(-1.0/UIScreen.main.scale)
                }
                else {
                    make.top.equalTo((lastButton?.snp.bottom)!).offset(-1.0/UIScreen.main.scale)
                    make.width.equalTo(firstButton!);
                }
                lastButton = btn
            })
            btn.setBackgroundImage(UIImage.xx_image(color: config.backgroundColor), for: .normal)
            btn.setBackgroundImage(UIImage.xx_image(color: config.backgroundColor), for: .disabled)
            btn.setBackgroundImage(UIImage.xx_image(color: config.itemPressedColor), for: .highlighted)
            btn.setTitle(item.title, for: .normal)
            btn.setTitleColor(item.highlight ? config.itemHighlightColor : config.itemNormalColor, for: .normal)
            btn.layer.borderWidth = 1.0 / UIScreen.main.scale
            btn.layer.borderColor = config.splitColor.cgColor
            btn.titleLabel?.font = (item == items.last) ? UIFont.boldSystemFont(ofSize: config.buttonFontSize) : UIFont.systemFont(ofSize: config.buttonFontSize)
            btn.isEnabled = !item.disabled
        }
        lastButton?.snp.makeConstraints({ (make) in
             make.bottom.equalTo((self.buttonView?.snp.bottom)!).offset(1.0 / UIScreen.main.scale)
        })
        self.cancelButton = UIButton.xx_button(target: self, action: #selector(actionCancel))
        self.addSubview(self.cancelButton!)
        self.cancelButton?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.buttonView!)
            make.height.equalTo(config.buttonHeight)
            make.top.equalTo(self.buttonView!.snp.bottom).offset(8)
        })
        self.cancelButton!.titleLabel?.font = UIFont.systemFont(ofSize: config.buttonFontSize)
        self.cancelButton!.setBackgroundImage(UIImage.xx_image(color: config.backgroundColor), for: .normal)
        self.cancelButton!.setBackgroundImage(UIImage.xx_image(color: config.backgroundColor), for: .highlighted)
        self.cancelButton!.setTitle(config.defaultTextCancel, for: .normal)
        self.cancelButton!.setTitleColor(config.itemNormalColor, for: .normal)
        
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo((self.cancelButton?.snp.bottom)!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func actionCancel() -> Void {
        self.hide()
    }
    @objc func actionButton(btn: UIButton?) -> Void {
        let item = self.actionItems![(btn?.tag)!]
        self.hide()
        if let handler = item.handler {
            handler(btn!.tag)
        }
    }
}

class XXSheetViewConfig: NSObject {
    var buttonHeight: CGFloat = 50
    var innerMargin: CGFloat = 19
    
    var titleFontSize: CGFloat = 14
    var buttonFontSize: CGFloat = 17
    
    var backgroundColor: UIColor = UIColor.init(xx_hex: 0xffffffff)
    var titleColor: UIColor = UIColor.init(xx_hex: 0x666666ff)
    var detailColor:UIColor = UIColor.init(xx_hex: 0x333333ff)
    var splitColor:UIColor = UIColor.init(xx_hex: 0xCCCCCCff)
    
    var itemNormalColor: UIColor = UIColor.init(xx_hex: 0x333333ff)
    var itemHighlightColor: UIColor = UIColor.init(xx_hex: 0xE76153ff)
    var itemPressedColor: UIColor = UIColor.init(xx_hex: 0xEFEDE7ff)
    var itemDisableColor: UIColor = UIColor.init(xx_hex: 0xccccccff)
    
    var defaultTextCancel: String = "取消"
    
    static let instance: XXSheetViewConfig = XXSheetViewConfig()
    
    class func globalConfig() -> XXSheetViewConfig {
        return instance
    }
}
