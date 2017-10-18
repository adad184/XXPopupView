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
        let block: (Int) -> Void = {
            (index: Int) in
            print("click on \(index)")
        }
        let items = [XXPopupItem.init(title: "Ok", type: .normal, handler: block),
                     XXPopupItem.init(title: "Cancel", type: .highlighted, handler: block)]
        let alert = XXAlertView.init(title: "Hello", detail: "Swift", items: items)
        alert.show()
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
        button.addTarget(self, action:  #selector(buttonTapAction(button:)), for: .touchUpInside)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

