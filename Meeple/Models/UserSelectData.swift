//
//  UserSelectData.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/03.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

final class UserSelectData: NSObject {
    
    class func jpnGenderList() -> [String] {
        let jpnGenderArray: [String] = ["男", "女"]
        return jpnGenderArray
    }
    
    class func genderList() -> [String] {
        let genderArray: [String] = ["male", "female"]
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
    
    class func selectedGradeString(opIndex: Int?) -> String {
        if let index = opIndex {
            let gradeList = self.gradeList()
            return gradeList[index]
        } else {
            return ""
        }
    }
    
    class func selectedRegionString(opIndex: Int?) -> String {
        if let index = opIndex {
            let regionList = self.regionList()
            return regionList[index]
        } else {
            return ""
        }
    }
    
    class func verifyIconImage(opIsVerified: Bool?) -> UIImage? {
        if let isVerified = opIsVerified, isVerified {
            return #imageLiteral(resourceName: "verifyIcon")
        } else {
            return nil
        }
    }
    
    class func tweetString(opTweet: String?) -> String {
        if let tweet = opTweet {
            return tweet
        } else {
            return ""
        }
    }
    
    class func stringToURL(opString: String?) -> URL? {
        if let urlString = opString {
            return URL(string: urlString)
        } else {
            return nil
        }
    }
    
//    class func selectedPersonalityString(opIndex: Int?) -> String {
//        if let index = opIndex {
//            let personalityList = self.personalityList()
//            return personalityList[index]
//        } else {
//            return ""
//        }
//    }
    
}

