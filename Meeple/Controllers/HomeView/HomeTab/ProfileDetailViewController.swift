//
//  ProfileDetailViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/08/10.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit
import Nuke
import FirebaseFirestore

class ProfileDetailViewController: UIViewController {
    
    @IBOutlet weak var profileImageView1: UIImageView!
    @IBOutlet weak var profileImageView2: UIImageView!
    @IBOutlet weak var profileDetailView: UIView!
    @IBOutlet weak var topContentView: UIView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var ageLabel1: UILabel!
    @IBOutlet weak var nameLabel1: UILabel!
    @IBOutlet weak var verifyImageView1: UIImageView!
    @IBOutlet weak var ageLabel2: UILabel!
    @IBOutlet weak var nameLabel2: UILabel!
    @IBOutlet weak var verifyImageView2: UIImageView!
    @IBOutlet weak var onlineStatusColorView: UIView!
    @IBOutlet weak var onlineStatusNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var introduceContentView: UIView!
    @IBOutlet weak var introduceTextView: UITextView!
    @IBOutlet weak var GroupInfoContentView: UIView!
    @IBOutlet weak var liquorAllowImageView: UIImageView!
    @IBOutlet weak var syntalityGradeImageView: UIImageView!
    @IBOutlet weak var detailInfoContentView: UIView!
    @IBOutlet weak var nameInfoLabel1: UILabel!
    @IBOutlet weak var ageInfoLabel1: UILabel!
    @IBOutlet weak var gradeInfoLabel1: UILabel!
    @IBOutlet weak var regionInfoLabel1: UILabel!
    @IBOutlet weak var heightInfoLabel1: UILabel!
    @IBOutlet weak var cigaretteInfoLabel1: UILabel!
    @IBOutlet weak var hobbyInfoLabel1: UILabel!
    @IBOutlet weak var nameInfoLabel2: UILabel!
    @IBOutlet weak var ageInfoLabel2: UILabel!
    @IBOutlet weak var gradeInfoLabel2: UILabel!
    @IBOutlet weak var regionInfoLabel2: UILabel!
    @IBOutlet weak var heightInfoLabel2: UILabel!
    @IBOutlet weak var cigaretteInfoLabel2: UILabel!
    @IBOutlet weak var hobbyInfoLabel2: UILabel!
    
    var lookingUserProfile = UserProfileModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        //レイアウトを整える(ナビゲーションバーはViewWillAppearで)
        prepareDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ナビゲーションバーの右側ボタン
        let moreButton = UIBarButtonItem(title: "︙", style: .plain, target: self, action: #selector(moreButtonPressed(_:)))
        moreButton.tintColor = ColorPalette.textColor()
        moreButton.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 20)], for: .normal)
        self.parent?.navigationItem.rightBarButtonItem = moreButton
        
        //コンテナビューからユーザーデータを取ってくる
        guard let parentView = self.parent as? ProfileDetailContainerViewController else {
            preconditionFailure("親ビュー（ContainerView）を取得できませんでした")
        }
        lookingUserProfile = parentView.selectedUser
        setProfileDetail()
    }
    
    func prepareDesign() {
        //画像下の詳細Viewの上角を丸く
        profileDetailView.layer.cornerRadius = 12
        profileDetailView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //各Viewの下辺にボーター
        topContentView.addBorderBottom(height: 0.5, color: ColorPalette.lightTextColor())
        introduceContentView.addBorderBottom(height: 0.5, color: ColorPalette.lightTextColor())
        GroupInfoContentView.addBorderBottom(height: 0.5, color: ColorPalette.lightTextColor())
        //ひとこと
        tweetTextView.layer.cornerRadius = 12
        tweetTextView.textContainerInset = UIEdgeInsets(top: 6, left: 10, bottom: 0, right: 10)
        //オンラインアイコン
        onlineStatusColorView.layer.cornerRadius = 5
    }
    
    func setProfileDetail() {
        //Nukeで画像をダウンロード（おそらくキャッシュ済みになってる）
        if let avatarImageURL1 = UserSelectData.stringToURL(opString: lookingUserProfile.mainImageURL1) {
            Nuke.loadImage(with: avatarImageURL1, into: profileImageView1)
        } else {
            profileImageView1.image = #imageLiteral(resourceName: "noneAvatarImage")
        }
        if let avatarImageURL2 = UserSelectData.stringToURL(opString: lookingUserProfile.mainImageURL2) {
            Nuke.loadImage(with: avatarImageURL2, into: profileImageView2)
        } else {
            profileImageView2.image = #imageLiteral(resourceName: "noneAvatarImage")
        }
        //画像下の居住地・年齢・名前・認証情報
        regionLabel.text = UserSelectData.selectedRegionString(opIndex: lookingUserProfile.region)
        if let age1 = lookingUserProfile.age1 {
            ageLabel1.text = age1.description + "歳"
        } else {
            ageLabel1.text = "-"
        }
        if let age2 = lookingUserProfile.age2 {
            ageLabel2.text = age2.description + "歳"
        } else {
            ageLabel2.text = "-"
        }
        nameLabel1.text = lookingUserProfile.name1
        nameLabel2.text = lookingUserProfile.name2
        if lookingUserProfile.isVerified1 {
            verifyImageView1.image = #imageLiteral(resourceName: "verifyIcon")
        } else {
            verifyImageView1.image = .none
        }
        if lookingUserProfile.isVerified2 {
            verifyImageView2.image = #imageLiteral(resourceName: "verifyIcon")
        } else {
            verifyImageView2.image = .none
        }
        //オンラインステータスのセット
        //ひとことのセット
        tweetTextView.text = lookingUserProfile.tweet
        //自己紹介のセット（まだプロフィールモデルにフィールドを設定してない）
        //ゲージ画像のセット
        switch lookingUserProfile.liquor {
        case 0:
            liquorAllowImageView.image = #imageLiteral(resourceName: "three-dots-1-600-min")
        case 1:
            liquorAllowImageView.image = #imageLiteral(resourceName: "three-dots-2-600-min")
        case 2:
            liquorAllowImageView.image = #imageLiteral(resourceName: "three-dots-3-600-min")
        default:
            liquorAllowImageView.image = #imageLiteral(resourceName: "three-dots-2-600-min")
        }
        
        switch lookingUserProfile.syntality {
        case 0:
            syntalityGradeImageView.image = #imageLiteral(resourceName: "five-dots-1-600-min")
        case 1:
            syntalityGradeImageView.image = #imageLiteral(resourceName: "five-dots-2-600-min")
        case 2:
            syntalityGradeImageView.image = #imageLiteral(resourceName: "five-dots-3-600-min")
        case 3:
            syntalityGradeImageView.image = #imageLiteral(resourceName: "five-dots-4-600-min")
        case 4:
            syntalityGradeImageView.image = #imageLiteral(resourceName: "five-dots-5-600-min")
        default:
            syntalityGradeImageView.image = #imageLiteral(resourceName: "five-dots-3-600-min")
        }
        //個人詳細のセット
        nameInfoLabel1.text = lookingUserProfile.name1
        nameInfoLabel2.text = lookingUserProfile.name2
        setIntLabel(label: ageInfoLabel1, opInt: lookingUserProfile.age1, unit: "歳")
        setIntLabel(label: ageInfoLabel2, opInt: lookingUserProfile.age2, unit: "歳")
        gradeInfoLabel1.text = UserSelectData.selectedGradeString(opIndex: lookingUserProfile.grade1)
        gradeInfoLabel2.text = UserSelectData.selectedGradeString(opIndex: lookingUserProfile.grade2)
        regionInfoLabel1.text = UserSelectData.selectedRegionString(opIndex: lookingUserProfile.region)
        regionInfoLabel2.text = UserSelectData.selectedRegionString(opIndex: lookingUserProfile.region)
        setIntLabel(label: heightInfoLabel1, opInt: lookingUserProfile.height1, unit: "cm")
        setIntLabel(label: heightInfoLabel2, opInt: lookingUserProfile.height2, unit: "cm")
        //タバコは１人ずつ設定できるようにする！
        let cigaretteInfo1 = UserSelectData.selectedCigaretteString(opIndex: lookingUserProfile.cigarette)
        let cigaretteInfo2 = UserSelectData.selectedCigaretteString(opIndex: lookingUserProfile.cigarette)
        if cigaretteInfo1 != "" {
            cigaretteInfoLabel1.text = cigaretteInfo1
        } else {
            cigaretteInfoLabel1.text = "-"
            cigaretteInfoLabel1.textColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
        }
        if cigaretteInfo2 != "" {
            cigaretteInfoLabel2.text = cigaretteInfo2
        } else {
            cigaretteInfoLabel2.text = "-"
            cigaretteInfoLabel2.textColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
        }
        //趣味も１人ずつ！
        setStringLabel(label: hobbyInfoLabel1, opString: lookingUserProfile.hobby)
        setStringLabel(label: hobbyInfoLabel2, opString: lookingUserProfile.hobby)
    }
    
    func setIntLabel(label: UILabel, opInt: Int?, unit: String) {
        if let intValue = opInt {
            label.text = intValue.description + unit
        } else {
            label.text = "-"
            label.textColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
        }
    }
    
    func setStringLabel(label: UILabel, opString: String?) {
        if let stringValue = opString {
            label.text = stringValue
        } else {
            label.text = "-"
            label.textColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
        }
    }
    
    @objc
    func moreButtonPressed(_ sender: Any) {
        print("ナビゲーションボタンがタップされました")
    }
    
}

extension UIView {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
