//
//  EmailEntryViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/01/16.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class EmailEntryViewController: UIViewController {

    
    @IBOutlet weak var EmailTextfield: UITextField!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //見た目を整える
        prepareDesign()
    }
    
    func prepareDesign() {
        //テキストフィールドのデザイン調整
        EmailTextfield.layer.cornerRadius = 5
        EmailTextfield.layer.borderWidth = 1
        EmailTextfield.layer.borderColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
        //メールを送信ボタンのデザイン調整
        sendEmailButton.layer.cornerRadius = 5
        //右上のクローズボタンのデザイン調整
        closeButton.setTitle("", for: .normal)
        closeButton.setImage(#imageLiteral(resourceName: "times"), for: .normal)
        closeButton.tintColor = #colorLiteral(red: 0.4039215686, green: 0.4039215686, blue: 0.4039215686, alpha: 1)
    }
    
    
    @IBAction func sendEmailButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToVerifyPasscode", sender: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
