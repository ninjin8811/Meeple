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
        //見た目を整える
        prepareDesign()
    }
    
    func prepareDesign() {
        //ログインボタンの見た目の変更
        facebookButton.layer.cornerRadius = 25
        facebookButton.setImage(#imageLiteral(resourceName: "fb-icon-75"), for: .normal)
        facebookButton.titleEdgeInsets.left = 10
        facebookButton.imageEdgeInsets.left = -40
        mailButton.layer.cornerRadius = 25
        mailButton.setImage(#imageLiteral(resourceName: "mail-icon-60"), for: .normal)
        mailButton.titleEdgeInsets.left = 15
        mailButton.imageEdgeInsets.left = -15
    }
    
    @IBAction func fbButtonPressed(_ sender: Any) {
        
    }

    @IBAction func emailButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToEmailEntry", sender: nil)
    }
    
}
