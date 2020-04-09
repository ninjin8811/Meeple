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
        SVProgressHUD.show()
        //グループ人数にはとりあえず2人を指定
        dcModel.mergeProfileData(people: "two") { (isMerged) in
            SVProgressHUD.dismiss()
            if isMerged == false {
                print("マージに失敗しました(EndRegisterView)")
                //アラートを出す
                let alert = UIAlertController(title: "データの保存に失敗", message: "もう一度お試しください。", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                //UserDefaultsにログイン履歴を記録
                let ud = UserDefaults.standard
                let loginDataDictionary: [String: Bool] = ["isLogin": true]
                ud.set(loginDataDictionary, forKey: "loginData")
                self.dismiss(animated: true, completion: nil)
                //UserDefaultsに性別を記録
                let genderList = UserSelectData.genderList()
                guard let myGenderIndex = DCModel.currentUserData.gender else {
                    preconditionFailure("DCModelにgenderデータが存在しませんでした")
                }
                var yourGenderIndex = 0
                if myGenderIndex == 0 {
                    yourGenderIndex += 1
                    let genderDataDictionary: [String: String] = ["myGender": genderList[myGenderIndex], "yourGender": genderList[yourGenderIndex]]
                    ud.set(genderDataDictionary, forKey: "genderData")
                } else {
                    let genderDataDictionary: [String: String] = ["myGender": genderList[myGenderIndex], "yourGender": genderList[yourGenderIndex]]
                    ud.set(genderDataDictionary, forKey: "genderData")
                }
                
                //userDefaultsの性別データを利用してメールを送信する処理
                self.dcModel.sendVerifyEmail { (isSent) in
                    if isSent == false {
                        print("メールデータの保存に失敗：EngRegisterView")
                        //ここにアラート出す処理書く
                    } else {
                        print("メールデータの保存に成功：EngRegisterView")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}
