//
//  AppDelegate.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/01/06.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let STORED_KEY = "loginData"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        //とりあえずログイン状態じゃないよって値を保存
//        let ud = UserDefaults.standard
//        let loginDataDictionary: [String: Bool] = ["isLogin": false]
//        ud.set(loginDataDictionary, forKey: STORED_KEY)
        
        //iOS12以下の対応しようと思ったけど全部SceleDelegateから実行されるからこの文いらない？
//        if #available(iOS 13, *) {
//        } else {
//            let window = UIWindow(frame: UIScreen.main.bounds)
//            self.window = window
//            window.makeKeyAndVisible()
//
//            let vc = HomeViewController()
//            window.rootViewController = vc
//        }
        return true
    }
    
    // facebook&Google&電話番号認証時に呼ばれる関数
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        guard let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String? else {
            preconditionFailure("認証設定のエラー")
        }
        // GoogleもしくはFacebook認証の場合、trueを返す
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // 電話番号認証の場合、trueを返す
        if Auth.auth().canHandle(url) {
            return true
        }
        return false
    }
    
    // 電話番号認証の場合に通知をHandel出来るかチェックする関数
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
        // エラーの時の処理を書く
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
