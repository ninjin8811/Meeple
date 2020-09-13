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
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
    }
    
    

}
