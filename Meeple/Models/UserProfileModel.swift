//
//  UserDataModel.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/03.
//  Copyright © 2020 Meeple. All rights reserved.
//

import Foundation
import CodableFirebase

//検索とホーム表示に使うデータは1段階目に置いておく
class UserProfileModel: Codable {
    var name1: String?
    var name2: String?
    var gender: Int?
    var region: Int?
    var grade1: Int?
    var grade2: Int?
    var mainImageURL1: String?
    var mainImageURL2: String?
    var verifyImageURL1: String?
    var verifyImageURL2: String?
    var isVerified1: Bool = false
    var isVerified2: Bool = false
    var updateDate: TimeInterval?
    var tweet: String?
    var syntality: Int?
    var cigarette: Int?
    var detailProfile: DetailProfileModel?
}

//プロフィールの詳細表示で使うデータ
class DetailProfileModel: Codable {
    var liquor: Int?
}

//検索条件設定、プロフィール設定のテーブルビューに使う
class DetailProfileData {
    var title = ""
    var termArray = [Any]()
    var setArray = [Int]()
}
