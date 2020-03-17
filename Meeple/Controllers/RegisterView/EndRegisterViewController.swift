//
//  EndRegisterViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/17.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit
import SVProgressHUD

class EndRegisterViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    let dcModel = DCModel()
    
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
        print("プロフィールデータデータをアップロードします：EngRegisterView")
        SVProgressHUD.show()
        dcModel.mergeProfileData { (isMerged) in
            SVProgressHUD.dismiss()
            if isMerged == false {
                print("マージに失敗しました(EndRegisterView)")
                //アラートを出す
                let alert = UIAlertController(title: "データの保存に失敗", message: "もう一度お試しください。", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                print("マージに成功(EndRegisterView)")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
