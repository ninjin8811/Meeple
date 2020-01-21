//
//  CheckTermsViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/01/18.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit
import Firebase

class CheckTermsViewController: UIViewController {

    @IBOutlet weak var checkBoxImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var termTextView: UITextView!
    
    var isChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //見た目を整える
        prepareDesign()
    }
    
    func prepareDesign() {
        //規約同意の文のデザイン
        let baseString = "私は18歳以上で独身です。Meepleの利用規約、\nプライバシーポリシーにも同意します。"
        let attributedString = NSMutableAttributedString(string: baseString)
        let termRange = NSString(string: baseString).range(of: "利用規約")
        let policyRange = NSString(string: baseString).range(of: "プライバシーポリシー")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        termTextView.textContainerInset = UIEdgeInsets(top: 2.5, left: 0, bottom: 0, right: 0)
        termTextView.textContainer.lineFragmentPadding = 0
        termTextView.isEditable = false
        termTextView.isSelectable = true
        termTextView.isScrollEnabled = false
        attributedString.addAttribute(.link, value: "https://google.com", range: termRange)
        attributedString.addAttribute(.link, value: "https://yahoo.com", range: policyRange)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSString(string: baseString).range(of: "私は18歳以上で独身です。Meepleの利用規約、"))
        termTextView.attributedText = attributedString
        termTextView.textColor = #colorLiteral(red: 0.4039215686, green: 0.4039215686, blue: 0.4039215686, alpha: 1)
        //チェックボックスイメージにタップ判定をつける
        checkBoxImage.isUserInteractionEnabled = true
        checkBoxImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkBoxTapped(_:))))
        //次へボタンが無効時のデザイン
        nextButton.layer.cornerRadius = 25
        nextButton.setTitleColor(ColorPalette.textColor(), for: .normal)
        nextButton.backgroundColor = ColorPalette.disabledColor()
        nextButton.isUserInteractionEnabled = false
        //遷移先ナビゲーションバーの戻るボタン
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
    }
    
    @objc
    func checkBoxTapped(_ sender: UITapGestureRecognizer) {
        isChecked = !isChecked
        if isChecked == true {
            //ボタンを有効時のデザインへ
            nextButton.isUserInteractionEnabled = true
            nextButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            nextButton.backgroundColor = ColorPalette.meepleColor()
            //チェックボックスの画像を変更
            checkBoxImage.image = #imageLiteral(resourceName: "checked-105")
        } else {
            //ボタンを無効時のデザインへ
            nextButton.isUserInteractionEnabled = false
            nextButton.setTitleColor(ColorPalette.textColor(), for: .normal)
            nextButton.backgroundColor = ColorPalette.disabledColor()
            //チェックボックスの画像を変更
            checkBoxImage.image = #imageLiteral(resourceName: "unchecked-105")
        }
        
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        print("次へボタンがタップされました")
        performSegue(withIdentifier: "goToNicknameRegister", sender: self)
    }
    
}
