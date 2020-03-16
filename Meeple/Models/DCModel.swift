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
//
//    func uploadImage(_ resizedImage: UIImage) {
//        SVProgressHUD.show()
//
//        guard let userID = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let imageRef = Storage.storage().reference().child("avatarImages").child("\(userID).jpg")
//
//        if let data = resizedImage.jpegData(compressionQuality: 1.0) {
//            imageRef.putData(data, metadata: nil) { _, error in
//
//                if error != nil {
//                    print("画像をアップロードできませんでした！")
//                } else {
//                    print("画像がアップロードされました！")
//
//                    imageRef.downloadURL(completion: { uploadedImageURL, error in
//
//                        if error != nil {
//                            print("ダウンロードURLが取得できませんでした！")
//                        } else {
//                            guard let imageURL = uploadedImageURL?.absoluteString else {
//                                return
//                            }
//                            self.profileData.imageURL = imageURL
//                            self.loadAvatarImage()
//                        }
//                    })
//                }
//            }
//        }
//        SVProgressHUD.dismiss()
//    }
    
    
//    //位置情報をRouteDataの中に保存する時に使う
//    func uploadLocation(_ index: Int, _ data: locationData, _ uid: String) {
//
//        routes[index].latestLocation = data
//        do {
//            let mergeLocationData = try FirestoreEncoder().encode(routes[index])
//            firestoreDB.collection("users").document(uid).collection("routes").document(documentIDarray[index]).setData(mergeLocationData, merge: true) { (error) in
//                if let errorMessage = error {
//                    print("Firestoreへの位置情報のマージに失敗しました：\(errorMessage)")
//                } else {
//                    print("位置情報をFirestoreへマージしました")
//                }
//            }
//        } catch {
//            print("エンコードに失敗しました：\(error)")
//        }
//    }
//
//    //地点の追加時に使う
//    func mergeSpotdata(_ index: Int, _ after: @escaping (Bool) -> Void) {
//        var isStored = false
//        guard let uid = Auth.auth().currentUser?.uid else {
//            preconditionFailure("ユーザーIDの取得に失敗しました")
//        }
//        let sinceDate = Date().timeIntervalSince1970
//        routes[index].updatedDate = sinceDate
//
//        do {
//            let mergeData = try FirestoreEncoder().encode(routes[index])
//            firestoreDB.collection("users").document(uid).collection("routes").document(documentIDarray[index]).setData(mergeData, merge: true) { (error) in
//                if let errorMessage = error {
//                    print("Firestoreへのデータのマージに失敗しました：\(errorMessage)")
//                } else {
//                    isStored = true
//                    print("データをFirestoreへ追加保存,削除しました")
//                }
//                after(isStored)
//            }
//        } catch {
//            print("エンコードに失敗しました：\(error)")
//        }
//    }
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

