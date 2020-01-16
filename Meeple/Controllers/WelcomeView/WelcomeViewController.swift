//
//  WelcomeViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/01/15.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ログインボタンの見た目の変更
        facebookButton.setTitle("Facebookではじめる", for: .normal)
        facebookButton.setImage(#imageLiteral(resourceName: "fb-icon-75"), for: .normal)
        facebookButton.titleEdgeInsets.left = CGFloat(10)
        facebookButton.imageEdgeInsets.left = CGFloat(-40)
        mailButton.setTitle("メールアドレスではじめる", for: .normal)
        mailButton.setImage(#imageLiteral(resourceName: "mail-icon-60"), for: .normal)
        mailButton.titleEdgeInsets.left = CGFloat(15)
        mailButton.imageEdgeInsets.left = CGFloat(-15)
    }
    

}
