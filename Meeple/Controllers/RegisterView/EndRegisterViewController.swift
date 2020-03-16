//
//  EndRegisterViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/17.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class EndRegisterViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //見た目を整える
        prepareDesign()
    }
    
    func prepareDesign() {
        //はじめるボタンのデザイン
        nextButton.layer.cornerRadius = 25
        nextButton.isUserInteractionEnabled = true
        nextButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        nextButton.backgroundColor = ColorPalette.meepleColor()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
    }
    
}
