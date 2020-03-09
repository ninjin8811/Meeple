//
//  ProfileImageRegisterViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/04.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class ProfileImageRegisterViewController: UIViewController {

    @IBOutlet weak var profileImage1: UIImageView!
    @IBOutlet weak var profileImage2: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var avatarBlock: UIView!
    
    var userProfile: UserProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //見た目を整える
        prepareDesign()
        
    }
    
    func prepareDesign() {
        //遷移先ナビゲーションバーの戻るボタン
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
        //アップロードボタンのデザイン
        uploadButton.layer.cornerRadius = 25
        uploadButton.setTitleColor(UIColor.white, for: .normal)
        uploadButton.backgroundColor = ColorPalette.meepleColor()
        uploadButton.isUserInteractionEnabled = true
        //2人分のアバターブロックのデザイン
        profileImage1.contentMode = .scaleAspectFill
        profileImage2.contentMode = .scaleAspectFill
        profileImage1.image = #imageLiteral(resourceName: "noneAvatar1")
        profileImage2.image = #imageLiteral(resourceName: "noneAvatar2")
        avatarBlock.backgroundColor = ColorPalette.lightTextColor()
        avatarBlock.layer.cornerRadius = 30
        avatarBlock.layer.borderColor = ColorPalette.lightTextColor().cgColor
        avatarBlock.layer.borderWidth = 2
        avatarBlock.layer.masksToBounds = true
    }

    @IBAction func uploadButtonPressed(_ sender: Any) {
    }
    @IBAction func skipButtonPressed(_ sender: Any) {
    }
}
