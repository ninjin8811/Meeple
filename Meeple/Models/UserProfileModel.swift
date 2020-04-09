//
//  UserDataModel.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/03.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit
import CodableFirebase

class UserProfileModel: Codable {
    var name1: String?
    var name2: String?
    var gender: Int?
    var region: Int?
    var grade1: Int?
    var grade2: Int?
    var mainImageURL1: String?
    var mainImageURL2: String?
    var detailProfile: DetailProfileModel?
    var verifyImageURL1: String?
    var verifyImageURL2: String?
    var isVerified1: Bool = false
    var isVerified2: Bool = false
    var updateDate: TimeInterval?
    var tweet: String?
}

class DetailProfileModel: Codable {
    var personality: Int?
    var liquor: Int?
}
