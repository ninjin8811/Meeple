//
//  WelcomeViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/01/15.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    
    var registerVC: CustomNavigationViewController?
    
    var authUI: FUIAuth {
        return  FUIAuth.defaultAuthUI()!
    }
    let providers: [FUIAuthProvider] = [
        FUIFacebookAuth(),
        FUIPhoneAuth(authUI: FUIAuth.defaultAuthUI()!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //見た目を整える
        prepareDesign()
        // authUIのデリゲートを設定
        self.authUI.delegate = self
        self.authUI.providers = providers
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let presentedVC = presentedViewController as? CustomNavigationViewController {
            registerVC = presentedVC
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if registerVC != nil {
            performSegue(withIdentifier: "goToHomeFromWelcome", sender: self)
        }
    }
    
    func prepareDesign() {
        //ログインボタンの見た目の変更
        facebookButton.layer.cornerRadius = 25
        facebookButton.setImage(#imageLiteral(resourceName: "fb-icon-75"), for: .normal)
        facebookButton.titleEdgeInsets.left = 10
        facebookButton.imageEdgeInsets.left = -40
        mailButton.layer.cornerRadius = 25
        mailButton.setImage(#imageLiteral(resourceName: "phone-icon-60"), for: .normal)
        mailButton.titleEdgeInsets.left = 15
        mailButton.imageEdgeInsets.left = -55
    }
    
    @IBAction func fbButtonPressed(_ sender: Any) {
        if let user = Auth.auth().currentUser?.uid {
            print("ログイン済み")
            print(user)
        } else {
            print("ログインデータがありませんでした")
        }
        verifyWithFB()
    }

    @IBAction func emailButtonPressed(_ sender: Any) {
        verifyWithPhone()
    }
}

extension WelcomeViewController: FUIAuthDelegate {

    func verifyWithFB() {
        if let fbProvider = FUIAuth.defaultAuthUI()?.providers[0] as? FUIFacebookAuth {
            fbProvider.signIn(withDefaultValue: nil, presenting: nil) { (opCredential, opError, _, _) in
                
                guard let credential = opCredential else {
                    print("Credentialデータが存在しませんでした")
                    return
                }
                
                if let error = opError {
                    print("エラー：\(error)")
                } else {
                    print("ログイン成功！！")
                    Auth.auth().signIn(with: credential) { (_, opError) in
                        if let error = opError {
                            print("サインインエラー：\(error)")
                        } else {
                            self.performSegue(withIdentifier: "goToRegister", sender: self)
                        }
                    }
                }
            }
        }
    }

    func verifyWithPhone() {
        if let phoneProvider = FUIAuth.defaultAuthUI()?.providers[1] as? FUIPhoneAuth {
            phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
        }
    }

//    //認証画面から離れた時に呼ばれる関数
//    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
//        if error == nil {
//            //認証に成功した時
//            print("認証に成功！！")
//            performSegue(withIdentifier: "goToRegister", sender: self)
//        } else {
//            //認証に失敗した時
//            print("認証に失敗！！！！")
//        }
//    }
}
