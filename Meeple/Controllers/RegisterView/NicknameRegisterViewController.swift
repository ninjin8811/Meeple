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
        //見た目を整える
        prepareDesign()
        //画面がタップされたらキーボードが消える設定
        hideKeyboardWhenTappedAround()
        //キーボードの入力判定
        name1TextField.addTarget(self, action: #selector(checkNameInput), for: .editingChanged)
        name2TextField.addTarget(self, action: #selector(checkNameInput), for: .editingChanged)
    }
    
    func prepareDesign() {
        //テキストフィールドのデザイン
        textfieldDesign(textfield: name1TextField)
        textfieldDesign(textfield: name2TextField)
        //遷移先ナビゲーションバーの戻るボタン
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
        //次へボタンが無効時のデザイン
        nextButton.layer.cornerRadius = 25
        nextButton.setTitleColor(ColorPalette.textColor(), for: .normal)
        nextButton.backgroundColor = ColorPalette.disabledColor()
        nextButton.isUserInteractionEnabled = false
    }
    
    func textfieldDesign(textfield: UITextField) {
        let placeholder = "入力してください"
        let attrPlaceholder = NSMutableAttributedString(string: placeholder)
        let placeholderRange = NSString(string: placeholder).range(of: placeholder)
        if let hiraginoBold = UIFont(name: "HiraginoSans-W6", size: 20) {
            //プレースホルダーの設定
            attrPlaceholder.addAttribute(.foregroundColor, value: ColorPalette.lightTextColor(), range: placeholderRange)
            attrPlaceholder.addAttribute(.font, value: hiraginoBold, range: placeholderRange)
            textfield.attributedPlaceholder = attrPlaceholder
            //入力テキストの設定
            textfield.font = hiraginoBold
            textfield.textColor = ColorPalette.textColor()
        } else {
            print("ヒラギノフォントが存在しませんでした")
        }
        //枠線を消す
        textfield.borderStyle = .none
    }
    
    //キーボードの入力判定
    @objc
    func checkNameInput() {
        guard let name1 = name1TextField.text else {
            return
        }
        guard let name2 = name2TextField.text else {
            return
        }
        if name1.isEmpty != true && name2.isEmpty != true {
            //ボタンを有効に
            nextButton.isUserInteractionEnabled = true
            nextButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            nextButton.backgroundColor = ColorPalette.meepleColor()
        } else {
            //ボタンを無効に
            nextButton.isUserInteractionEnabled = false
            nextButton.setTitleColor(ColorPalette.textColor(), for: .normal)
            nextButton.backgroundColor = ColorPalette.disabledColor()
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToGenderRegister", sender: self)
    }
    
}

//キーボード部分以外をタップしたらキーボードが消える設定
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }
}
