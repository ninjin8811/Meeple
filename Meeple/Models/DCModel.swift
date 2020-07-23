//
//  DCModel.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/16.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase
import InstantSearchClient

class DCModel {
    //ただ1つ保持しておくデータ
    static var currentUserData = UserProfileModel()
    static var userList = [UserProfileModel]()
    static var query = Query()
    static var loadable = false
    //Firebaseのリファレンス
    let firestoreDB = Firestore.firestore()
    //ユーザーの選択データ配列
    let genderList = UserSelectData.genderList()
    //Algoliaの接続情報
    let algoliaClient = Client(appID: "9BTYNTVIW6", apiKey: "63f858fb93ab8d443357c11110da388f")
    
    //MARK:- データのアップロード
    //プロフィール画像のアップロード処理
    func uploadProfileImage(tag: Int, image: UIImage, storageRef: StorageReference, _ after: @escaping (Bool) -> Void) {
        var isStored = false
        //メタデータを設定
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        //UIImageをjpegデータに変換
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            preconditionFailure("UIImageをjpegに変換できませんでした")
        }
        //画像のアップロード
        storageRef.putData(imageData, metadata: metaData) { (_, error) in
            if let error = error {
                print("画像のアップロードに失敗しました\(error)")
            } else {
                print("画像をアップロードしました")
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("画像のダウンロードURLの取得に失敗しました\(error)")
                    } else {
                        guard let downloadURL = url?.absoluteString else {
                            preconditionFailure("URLからStringの変換に失敗しました")
                        }
                        //downloadURLの保存
                        if tag == 1 {
                            DCModel.currentUserData.mainImageURL1 = downloadURL
                        } else if tag == 2 {
                            DCModel.currentUserData.mainImageURL2 = downloadURL
                        }
                        //保存成功フラグ
                        isStored = true
                    }
                    after(isStored)
                }
            }
        }
    }
    
    //認証用画像のアップロード処理(今のところプロフィール画像のアップロードとほぼ同じ)
    func uploadVerifyImage(tag: Int, image: UIImage, storageRef: StorageReference, _ after: @escaping (Bool) -> Void) {
        var isStored = false
        //メタデータを設定
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        //UIImageをjpegデータに変換
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            preconditionFailure("UIImageをjpegに変換できませんでした")
        }
        //画像のアップロード
        storageRef.putData(imageData, metadata: metaData) { (_, error) in
            if let error = error {
                print("画像のアップロードに失敗しました\(error)")
            } else {
                print("画像をアップロードしました:DCModel.uploadVerifyImage")
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("画像のダウンロードURLの取得に失敗しました\(error)")
                    } else {
                        guard let downloadURL = url?.absoluteString else {
                            preconditionFailure("URLからStringの変換に失敗しました")
                        }
                        //downloadURLの保存
                        if tag == 1 {
                            DCModel.currentUserData.verifyImageURL1 = downloadURL
                        } else if tag == 2 {
                            DCModel.currentUserData.verifyImageURL2 = downloadURL
                        }
                        //保存成功フラグ
                        isStored = true
                    }
                    after(isStored)
                }
            }
        }
    }
    //画像認証メールを送る
    func sendVerifyEmail(_ after: @escaping (Bool) -> Void) {
        var isSent = false
        guard let userID = Auth.auth().currentUser?.uid else {
            preconditionFailure("ユーザーIDの取得に失敗：DCModel, sendVerifyEmail")
        }
        //UserDefaultsから性別データを取得
        let genderData = UserSelectData.selectedGenderString()
        guard let myGender = genderData["myGender"] as? String else {
            preconditionFailure("UserDefaultsにgenderDataが存在しませんでした")
        }
        //メールを送るリスト
        let mailList: [String] = [
            "fumiya8811@gmail.com",
            "stratoyamao@gmail.com",
            "chomo1ungma.zwei@gmail.com",
            "kindsun884.730@gmail.com"
        ]
        //urlを生成
        let verifyURL1 = "https://meeple-1af15.web.app/verify.html?gender=\(myGender)&numOfPeople=two&userID=\(userID)&selectedIndivisual=1"
        let verifyURL2 = "https://meeple-1af15.web.app/verify.html?gender=\(myGender)&numOfPeople=two&userID=\(userID)&selectedIndivisual=2"
        guard let name1 = DCModel.currentUserData.name1, let name2 = DCModel.currentUserData.name2 else {
            preconditionFailure("ユーザーの名前を取得できませんでした:DCModel:sendVerifyEmail")
        }
        //メール本文
        let messageData: [String: Any] = [
            "message": "認証待ち / \(name1)&\(name2)",
            "subject": "認証待ち / \(name1)&\(name2)",
            "text": "新たなユーザーが学生証を登録しました。\nURLから認証作業を行ってください。\n\n1人目: \(verifyURL1)\n\n,2人目: \(verifyURL2)",
            "html": "新たなユーザーが学生証を登録しました。\nURLから認証作業を行ってください。\n\n1人目: <a href='\(verifyURL1)'>ここをクリック</a>\n\n,2人目: <a href='\(verifyURL2)'>ここをクリック</a>"
        ]
        //ユーザードキュメントまでのパス
        let userPath: [String: Any] = [
            "gender": myGender,
            "numOfPeople": "two",
            "userID": userID
        ]
        //Firestoreにアップするメールデータ
        let mailData: [String: Any] = [
            "to": mailList,
            "message": messageData,
            "path": userPath
        ]
        firestoreDB.collection("mail").addDocument(data: mailData) { (error) in
            if let error = error {
                print("メールデータをアップロードしました：（DCModel）→\(error)")
            } else {
                print("メールデータをアップロードしました")
                isSent = true
            }
            after(isSent)
        }
    }
    
    //プロフィールデータのアップロード処理(RegisterViewで使うから性別の取得方法はこれでいい)
    func mergeProfileData(people: String, _ after: @escaping (Bool) -> Void) {
        var isMerged = false
        guard let userID = Auth.auth().currentUser?.uid else {
            preconditionFailure("ユーザーIDを取得できませんでした：mergeProfileData")
        }
        let uploadedDate = Date().timeIntervalSince1970
        DCModel.currentUserData.updateDate = uploadedDate
        guard let genderIndex = DCModel.currentUserData.gender else {
            preconditionFailure("性別データがありませんでした：mergeProfileData")
        }
        do {
            let mergeData = try FirestoreEncoder().encode(DCModel.currentUserData)
            firestoreDB.collection("users").document(genderList[genderIndex]).collection(people).document(userID).setData(mergeData, merge: true) { (error) in
                if let error = error {
                    print("プロフィールデータのマージに失敗：\(error)")
                } else {
                    print("プロフィールデータのマージに成功")
                    isMerged = true
                }
                after(isMerged)
            }
        } catch {
            print("プロフィールデータのエンコードに失敗しました：\(error)")
        }
    }
    
    //MARK:- データのダウンロード
    //ユーザーデータを取得する処理
    func fetchHomeUserData(_ after: @escaping (Bool) -> Void) {
        var isFetched = false
        //UserDefaultsから性別データを取得
        let genderData = UserSelectData.selectedGenderString()
        guard let yourGender = genderData["yourGender"] as? String else {
            preconditionFailure("UserDefaultsにgenderDataが存在しませんでした")
        }
        //とりあえず2人グループで指定してユーザーデータを取得
        firestoreDB.collection("users").document(yourGender).collection("two").getDocuments { (snapshots, error) in
            if error != nil {
                print("ユーザーデータの取得に失敗しました：fetchHomeUserData")
            } else {
                DCModel.userList.removeAll()
                isFetched = true
                guard let snap = snapshots else {
                    preconditionFailure("snapshotsデータが存在しませんでした：fetchHomeUserData")
                }
                print("取得したデータの個数：\(snap.documents.count)")
                for document in snap.documents {
                    do {
                        print("データの取得に成功：fetchHomeUserData")
                        let data = try FirestoreDecoder().decode(UserProfileModel.self, from: document.data())
                        DCModel.userList.append(data)
                    } catch {
                        print("取得したデータのデコードに失敗しました！")
                    }
                }
            }
            after(isFetched)
        }
    }
    
    //Algoliaから検索用データを取得
    func searchUserAlgolia(_ after: @escaping (Bool) -> Void) {
        var isFetched = false
        let index = algoliaClient.index(withName: UserSelectData.getAlgoliaIndexName())
        DCModel.query.page = 0
        if let currentPage = DCModel.query.page {
            DCModel.query.page = currentPage + 1
        } else {
            DCModel.query.page = 0
        }
        
        index.search(DCModel.query) { (opRes, err) in
            if let err = err {
                print("検索に失敗：\(err)")
            } else {
                isFetched = true
                guard let res = opRes, let nbHits = res["nbHits"] as? Int else {
                    preconditionFailure("レスポンスが存在しませんでした：searchUserAlgolia")
                }
                
                if nbHits == 0 {
                    print("結果が0でした")
                } else {
                    guard let userNSArray = res["hits"] as? NSArray else {
                        preconditionFailure("jsonデータをStringに変換できませんでした：searchUserAlgolia")
                    }
                    print("ヒット数：\(nbHits)")
                    self.parseAlgoliaUserData(userNSArray: userNSArray)
                }
                //最後のページ読み込みの場合これ以上読み込めないようにする
                DCModel.loadable = nbHits > DCModel.userList.count
            }
            after(isFetched)
        }
    }
    
    //Algoliaのデータをホーム画面表示用に変更
    func parseAlgoliaUserData(userNSArray: NSArray) {
        let decoder = JSONDecoder()
        do {
            guard let userDicArray = userNSArray as? [[String: Any]] else {
                preconditionFailure("変換に失敗：parseAlgoliaUserData")
            }
            let jsonData = try JSONSerialization.data(withJSONObject: userDicArray)
            let decodedData = try decoder.decode([UserProfileModel].self, from: jsonData)
            DCModel.userList.append(contentsOf: decodedData)
        } catch {
            print("JSONのデコードに失敗しました：parseAlgoliaUserData")
        }
    }
    
    
    //MARK:- ユーザーを送りまくる
    //ユーザーを送りまくる
    func sendUsers() {
        for i in 1...40 {
            let addData = UserProfileModel()
            addData.name1 = "男\(i)"
            addData.name2 = "男\(i)-2"
            addData.age1 = 20
            addData.age2 = 21
            addData.height1 = 165 + i
            addData.height2 = 170 + i
            addData.gender = 0
            addData.grade1 = 3
            addData.grade2 = 2
            addData.isVerified1 = true
            addData.isVerified2 = true
            addData.tweet = "よろしくお願いします-\(i)"
            addData.updateDate = Date().timeIntervalSince1970
            addData.syntality = 3
            addData.cigarette = 1
            addData.liquor = 1
            do {
                let encodedData = try FirestoreEncoder().encode(addData)
                firestoreDB.collection("users").document("female").collection("two").addDocument(data: encodedData) { (error) in
                    if let error = error {
                        print("プロフィールデータのアップロードに失敗:\(error)")
                    } else {
                        print("成功-\(i)")
                    }
                }
            } catch {
                print("プロフィールデータのエンコードに失敗しました：\(error)")
            }
        }
    }
//
//    var ref = db.collection("users") as Query
//
//    for i in 0..<child.count {
//        let temp = ref.whereField(child[i], isEqualTo: equelValue[i])
//        ref = temp
//    }
//    ref.getDocuments { (snapshots, error) in
//        if error != nil {
//            print("ユーザーの検索に失敗しました！")
//        } else {
//            guard let snap = snapshots else {
//                preconditionFailure("データの取得に失敗しました！")
//            }
//            for document in snap.documents {
//                do {
//                    let data = try FirestoreDecoder().decode(Profile.self, from: document.data())
//                    self.list.append(data)
//                } catch {
//                    print("取得したデータのデコードに失敗しました！")
//                }
//            }
//        }
//        self.goToPreviousView()
//    }

    
    //MARK:- アップロードデータの作成

}


