//
//  SceneDelegate.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/01/06.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit
import Firebase

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //SVProgressをXCode11に適応
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            preconditionFailure("Appdelegateのキャストに失敗")
        }
        appDelegate.window = self.window
        //windowを生成
        guard let scene = scene as? UIWindowScene else {
            return
        }
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.makeKeyAndVisible()
        //UserDafaultsからログイン状態を確認して画面を決定
        if let loginData = UserDefaults.standard.dictionary(forKey: "loginData") {
            if let isLogin = loginData["isLogin"] as? Bool {
                if isLogin == true {
                    //ログイン履歴があったとき、checkIsLoginFirebaseから画面を選ぶ
                    print("ログイン履歴がありました")
                    checkIsLoginFirebase(window: window)
                } else {
                    //ログイン履歴がなかったとき
                    print("ログイン履歴がありませんでした")
                    goToWelcomeView(window: window)
                }
            }
        } else {
            //初回起動
            print("初めての起動です")
            goToWelcomeView(window: window)
        }
    }
    
    //Firebaseにログイン状態かどうかのチェック(履歴＋Firebase)
    func checkIsLoginFirebase(window: UIWindow) {
        if let _ = Auth.auth().currentUser?.uid {
            //ここにログイン試行処理も書く（FBのパスワードを変えた時に変になる）
            //起動画面を変えてる(本来ならHomeview)
//            goToRegisterView(window: window)
            goToWelcomeView(window: window)
//            goToHomeView(window: window)
        } else {
            goToWelcomeView(window: window)
        }
    }
    
    func goToWelcomeView(window: UIWindow) {
        let welcomeStoryboard = UIStoryboard(name: "Welcome", bundle: nil)
        let welcomeVC = welcomeStoryboard.instantiateViewController(identifier: "Welcome")
        window.rootViewController = welcomeVC
    }

    func goToHomeView(window: UIWindow) {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeVC = homeStoryboard.instantiateViewController(identifier: "Home")
        window.rootViewController = homeVC
    }
    
    func goToRegisterView(window: UIWindow) {
        let registerStoryboard = UIStoryboard(name: "Register", bundle: nil)
        let registerVC = registerStoryboard.instantiateViewController(identifier: "Register")
//        let registerVC = registerStoryboard.instantiateViewController(identifier: "goToCrop")
        window.rootViewController = registerVC
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

