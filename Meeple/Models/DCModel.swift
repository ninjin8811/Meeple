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
    //Firebaseのリファレンス
    let firestoreDB = Firestore.firestore()
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
    
    //プロフィールデータのアップロード処理
    func mergeProfileData(_ after: @escaping (Bool) -> Void) {
        var isMerged = false
        guard let userID = Auth.auth().currentUser?.uid else {
            preconditionFailure("ユーザーIDを取得できませんでした：mergeProfileData")
        }
        let uploadedDate = Date().timeIntervalSince1970
        DCModel.currentUserData.updateDate = uploadedDate
        do {
            let mergeData = try FirestoreEncoder().encode(DCModel.currentUserData)
            firestoreDB.collection("users").document(userID).setData(mergeData, merge: true) { (error) in
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

//
//    //SchoolDataを取得する時に使う
//    func fetchSchoolData(_ after: @escaping (Bool) -> Void) {
//        var isFetched = false
//
//        firestoreDB.collection("schools").getDocuments { (snapshots, error) in
//            if let error = error {
//                print("自動車学校データの取得に失敗しました：\(error)")
//            } else {
//                print("自動車学校データを取得しました")
//                self.schools.removeAll()
//
//                guard let fetchedSchoolData = snapshots else {
//                    preconditionFailure("snapshotsに自動車学校データが存在しませんでした")
//                }
//                for document in fetchedSchoolData.documents {
//                    do {
//                        let addSchoolData = try FirestoreDecoder().decode(SchoolData.self, from: document.data())
//                        self.schools.append(addSchoolData)
//                        isFetched = true
//                    } catch {
//                        print("取得した自動車学校データのデコードに失敗しました")
//                    }
//                }
//                print(self.schools)
//            }
//            after(isFetched)
//        }
//    }
//
//    //各自動車学校の路線データを全て取得する時に使う
//    func fetchRouteData(_ schoolID: String, _ after: @escaping (Bool) -> Void) {
//        var isFetched = false
//
//        firestoreDB.collection("users").document(schoolID).collection("routes").getDocuments { (snapshots, error) in
//            if let error = error {
//                print("路線データの取得に失敗しました：\(error)")
//            } else {
//                print("路線データを取得しました")
//                self.routes.removeAll()
//                self.documentIDarray.removeAll()
//
//                guard let fetchedData = snapshots else {
//                    preconditionFailure("snapshotsにデータが存在しませんでした")
//                }
//                for document in fetchedData.documents {
//                    do {
//                        let addRouteData = try FirestoreDecoder().decode(RouteData.self, from: document.data())
//                        self.routes.append(addRouteData)
//                        self.documentIDarray.append(document.documentID)
//                        isFetched = true
//                    } catch {
//                        print("Firestoreから取得したドキュメントのデコードに失敗しました")
//                    }
//                }
//                print(self.routes)
//            }
//            after(isFetched)
//        }
//    }
//
    
//    func storeData(_ data: Any, _ after: @escaping (Bool) -> Void) {
//        var isStored = false
//        guard let uid = Auth.auth().currentUser?.uid else {
//            preconditionFailure("ユーザーIDの取得に失敗しました")
//        }
//        guard var dictionaryData = data as? [String: Any] else {
//            preconditionFailure("保存する路線データを辞書型に変換できませんでした")
//        }
//        let sinceDate = Date().timeIntervalSince1970
//        dictionaryData["updatedDate"] = sinceDate
//        firestoreDB.collection("users").document(uid).collection("routes").addDocument(data: dictionaryData) { (error) in
//            if let errorMessege = error {
//                print("FireStoreへのデータの保存に失敗しました：\(errorMessege)")
//            } else {
//                isStored = true
//                print("データをFirestoreへ保存しました")
//            }
//            after(isStored)
//        }
//    }
}

