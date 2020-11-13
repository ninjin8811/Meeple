//
//  ProfileDetailContainerViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/08/29.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class ProfileDetailContainerViewController: UIViewController {

    @IBOutlet weak var likeButton: UIButton!
    var selectedUser = UserProfileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //いいねボタンのデザイン
        likeButton.layer.cornerRadius = 25
        likeButton.layer.shadowPath = CGPath(roundedRect: CGRect(x: 0, y: 12, width: 320, height: 50), cornerWidth: 25, cornerHeight: 25, transform: nil)
        likeButton.layer.shadowColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
        likeButton.layer.shadowOpacity = 0.4
        likeButton.layer.shadowRadius = 5
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
    }
    
    

}
