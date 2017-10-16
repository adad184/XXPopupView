//
//  XXPopupItem.swift
//  XXPopupView
//
//  Created by Tsing on 2017/10/16.
//  Copyright © 2017年 tsing. All rights reserved.
//

import UIKit

typealias XXPopupItemHandler = (_ index: Int) ->Void
enum XXItemType {
    case normal
    case highlight
    case disbaled
}
class XXPopupItem: NSObject {
    var highlight: Bool = false
    var disabled: Bool = false
    var title: String?
    var color: UIColor?
    var handler: XXPopupItemHandler?
    init(title: String, type: XXItemType, handler: @escaping XXPopupItemHandler) {
        self.title = title
        self.handler = handler
        switch type {
        case .highlight:
            self.highlight = true
        case .disbaled:
            self.disabled = true
        default:
            break
        }
    }
}
