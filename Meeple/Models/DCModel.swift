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

class DCModel {
    //ただ1つ保持しておくデータ
    static var currentUserData = UserProfileModel()
    static var userList = [UserProfileModel]()
    //Firebaseのリファレンス
    let firestoreDB = Firestore.firestore()
    //ユーザーの選択データ配列
    let genderList = UserSelectData.genderList()
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
                print("画像をアップロードしました")
                isStored = true
            }
            after(isStored)
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
    
    //ユーザーデータを取得する処理
    func fetchHomeUserData(_ after: @escaping (Bool) -> Void) {
        var isFetched = false
        //UserDefaultsから性別データを取得する処理を書く
        let genderData = UserSelectData.selectedGenderString()
        guard let youGender = genderData["youGender"] as? String else {
            preconditionFailure("UserDefaultsにgenderDataが存在しませんでした")
        }
        //とりあえず2人グループで指定してユーザーデータを取得
        firestoreDB.collection("users").document(youGender).collection("two").getDocuments { (snapshots, error) in
            if error != nil {
                print("ユーザーデータの取得に失敗しました：fetchHomeUserData")
            } else {
                isFetched = true
                guard let snap = snapshots else {
                    preconditionFailure("snapshotsデータが存在しませんでした：fetchHomeUserData")
                }
                for document in snap.documents {
                    do {
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

}

