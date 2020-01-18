//
//  HomeViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/01/14.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            print("サインアウトします")
        } catch {
            print("サインアウトエラー")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
