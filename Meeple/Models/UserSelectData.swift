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
            "おとなしい",
            "おとなしい方",
            "普通",
            "明るい方",
            "明るい"
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
    
    class func cigaretteList() -> [String] {
        let cigaretteArray: [String] = [
            "吸う",
            "たまに吸う",
            "吸わない"
        ]
        return cigaretteArray
    }
    
    class func ageList() -> [Int] {
        var ageArray = [Int]()
        for age in 18...29 {
            ageArray.append(age)
        }
        return ageArray
    }
    
    class func heightList() -> [Int] {
        var heightArray = [Int]()
        for count in 130...200 {
            heightArray.append(count)
        }
        return heightArray
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
    
    //検索条件設定のテーブルビューに使う
    class func termLists() -> [DetailProfileData] {
        var lists = [DetailProfileData]()
        let data1 = DetailProfileData()
        let data2 = DetailProfileData()
        let data3 = DetailProfileData()
        let data4 = DetailProfileData()
        let data5 = DetailProfileData()
        let data6 = DetailProfileData()
        data1.title = "年齢"
        data2.title = "学年"
        data3.title = "居住地"
        data4.title = "身長"
        data5.title = "性格"
        data6.title = "たばこ"
        data1.termArray = self.ageList()
        data2.termArray = self.gradeList()
        data3.termArray = self.regionList()
        data4.termArray = self.heightList()
        data5.termArray = self.personalityList()
        data6.termArray = self.cigaretteList()
        lists.append(data1)
        lists.append(data2)
        lists.append(data3)
        lists.append(data4)
        lists.append(data5)
        lists.append(data6)
        return lists
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

