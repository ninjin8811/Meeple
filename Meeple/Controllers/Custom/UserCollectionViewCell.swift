//
//  UserCollectionViewCell.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/20.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarBlockView: UIView!
    @IBOutlet weak var profileImageView1: UIImageView!
    @IBOutlet weak var profileImageView2: UIImageView!
    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var onlineIconView: UIImageView!
    @IBOutlet weak var gradeLabel1: UILabel!
    @IBOutlet weak var gradeLabel2: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var verifyIconView1: UIImageView!
    @IBOutlet weak var verifyIconView2: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //見た目を整える
        prepareDesign()
    }
    
    func prepareDesign() {
        //アバターブロックの設定
        avatarBlockView.backgroundColor = ColorPalette.lightTextColor()
        avatarBlockView.layer.cornerRadius = 25
        avatarBlockView.layer.masksToBounds = true
        //2人分のアバターイメージの設定
        profileImageView1.contentMode = .scaleAspectFill
        profileImageView2.contentMode = .scaleAspectFill
        profileImageView1.image = #imageLiteral(resourceName: "noneAvatarImage")
        profileImageView2.image = #imageLiteral(resourceName: "noneAvatarImage")
        //ハイライトビューの設定
        highlightView.backgroundColor = .clear
        //ひとことビューの設定
        tweetTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tweetTextView.textContainer.lineFragmentPadding = 0
        tweetTextView.isEditable = false
        tweetTextView.isScrollEnabled = false
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "UserCollectionViewCell", bundle: nil)
    }

}
