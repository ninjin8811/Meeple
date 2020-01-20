//
//  CustomNavigationViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/01/20.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class CustomNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup() {
        self.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationBar.tintColor = #colorLiteral(red: 0.4039215686, green: 0.4039215686, blue: 0.4039215686, alpha: 1)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }


}
