//
//  UserSelectData.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/03.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

final class UserSelectData: NSObject {
    
    class func genderList() -> [String] {
        let genderArray: [String] = ["男", "女"]
        return genderArray
    }
    
    class func regionList() -> [String] {
        let regionArray: [String] = [
            "大阪",
            "奈良",
            "京都",
            "兵庫",
            "和歌山"
        ]
        return regionArray
    }
    
    class func gradeList() -> [String] {
        let gradeArray: [String] = [
            "大学1年",
            "大学2年",
            "大学3年",
            "大学4年",
            "院1年",
            "院2年",
            "専門1年",
            "専門2年"
        ]
        return gradeArray
    }
    
    class func personalityList() -> [String] {
        let personalityArray: [String] = [
            "1. おとなしい",
            "2. おとなしい方",
            "3. 普通",
            "4. 明るい方",
            "5. 明るい"
        ]
        return personalityArray
    }
    
    class func liquorList() -> [String] {
        let liquorArray: [String] = [
            "あり",
            "どちらでもいい",
            "なし"
        ]
        return liquorArray
    }
    
    class func selectedGenderString() -> [String: Any] {
        if let genderData = UserDefaults.standard.dictionary(forKey: "genderData") {
            return genderData
        } else {
            return [String: Any]()
        }
    }
}

