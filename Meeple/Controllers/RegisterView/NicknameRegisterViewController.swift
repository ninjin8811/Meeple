//
//  NicknameRegisterViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/01/19.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class NicknameRegisterViewController: UIViewController {

    @IBOutlet weak var name1TextField: UITextField!
    @IBOutlet weak var name2TextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareDesign()
    }
    
    func prepareDesign() {
        //遷移先ナビゲーションバーの戻るボタン
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
    }

}
