//
//  ViewController.swift
//  XXPopupView
//
//  Created by History on 2017/10/15.
//  Copyright © 2017年 tsing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @objc func buttonTapAction(button: UIButton) {
        switch button.tag {
        case 1:
            let block: (Int) -> Void = {
                (index: Int) in
                print("click on \(index)")
            }
            let items = [XXPopupItem.init(title: "Ok", type: .normal, handler: block),
                         XXPopupItem.init(title: "Cancel", type: .highlighted, handler: block)]
            let alert = XXAlertView.init(title: "Hello", detail: "Swift", items: items)
            alert.show()
        case 2:
            let block: (Int) -> Void = {
                (index: Int) in
                print("click on \(index)")
            }
            let items = [XXPopupItem.init(title: "Ok", type: .normal, handler: block),
                         XXPopupItem.init(title: "Cancel", type: .highlighted, handler: block)]
            let sheet = XXSheetView.init(title: "Alert", items: items)
            sheet.show()
        default:
            break
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIButton.init(type: .system)
        button.setTitle("Alert", for: .normal)
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        button.tag = 1
        button.addTarget(self, action:  #selector(buttonTapAction(button:)), for: .touchUpInside)
        
        let button2 = UIButton.init(type: .system)
        button2.setTitle("Sheet", for: .normal)
        self.view.addSubview(button2)
        button2.snp.makeConstraints { (make) in
            make.top.equalTo(button.snp.bottom)
            make.centerX.equalTo(self.view)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        button2.tag = 2
        button2.addTarget(self, action:  #selector(buttonTapAction(button:)), for: .touchUpInside)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

