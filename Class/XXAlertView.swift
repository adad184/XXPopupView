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

}


class XXAlertViewConfig: NSObject {
    var width: Float = 275
    var buttonHeight: Float = 50
    var innerMargin: Float = 25
    var cornerRadius: Float = 5
    
    var titleFontSize: Float = 18
    var detailFontSize: Float = 14
    var buttonFontSize: Float = 17
    
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
