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
    @IBOutlet weak var regionRabel: UILabel!
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
    
    static var lookingUserProfile = UserProfileModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        //見た目を整える(ナビゲーションバーはViewWillAppearで)
        prepareDesign()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ナビゲーションバーの右側ボタン
        let moreButton = UIBarButtonItem(title: "︙", style: .plain, target: self, action: #selector(moreButtonPressed(_:)))
        moreButton.tintColor = ColorPalette.textColor()
        moreButton.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 20)], for: .normal)
        self.parent?.navigationItem.rightBarButtonItem = moreButton
    }
    
    func prepareDesign() {
        //画像下の詳細Viewの上角を丸く
        profileDetailView.layer.cornerRadius = 15
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
    
    @objc
    func moreButtonPressed(_ sender: Any) {
        print("ナビゲーションボタンがタップされました")
        print(self.parent)
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
