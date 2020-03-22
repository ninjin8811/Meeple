//
//  RegionRegisterViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/03.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class RegionRegisterViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    var selectedIndexPath: IndexPath?
    let regionList = UserSelectData.regionList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //見た目を整える
        prepareDesign()
        //テーブルビューの設定
        tableview.register(RegisterTableViewCell.nib(), forCellReuseIdentifier: "regionCell")
        tableview.isScrollEnabled = false
        tableview.separatorStyle = .none
    }
    
    func prepareDesign() {
        //遷移先ナビゲーションバーの戻るボタン
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
        //次へボタンが無効時のデザイン
        nextButton.layer.cornerRadius = 25
        nextButton.setTitleColor(ColorPalette.textColor(), for: .normal)
        nextButton.backgroundColor = ColorPalette.disabledColor()
        nextButton.isUserInteractionEnabled = false
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        DCModel.currentUserData.region = selectedIndexPath?.row
        performSegue(withIdentifier: "goToGradeRegister", sender: self)
    }
}

extension RegionRegisterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "regionCell") as? RegisterTableViewCell {
            cell.titleLabel.text = regionList[indexPath.row]
            cell.titleLabel.textColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
            cell.checkmarkImage.image = nil
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(40)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選択されていたセルのデザインを元に戻す
        if let deselectIndexPath = selectedIndexPath {
            if let deselectCell = tableView.cellForRow(at: deselectIndexPath) as? RegisterTableViewCell {
                deselectCell.titleLabel.textColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
                deselectCell.checkmarkImage.image = nil
            } else {
                print("選択解除するセルのキャストに失敗")
            }
        }
        //新しく選択されたインデックスパスを更新
        selectedIndexPath = indexPath
        //新しく選択されたセルのデザインをチェック済みにする
        if let cell = tableView.cellForRow(at: indexPath) as? RegisterTableViewCell {
            cell.titleLabel.textColor = #colorLiteral(red: 0.8784313725, green: 0.4, blue: 0.3450980392, alpha: 1)
            cell.checkmarkImage.image = #imageLiteral(resourceName: "checkmark-60")
        } else {
            print("選択したセルのキャストに失敗")
        }
        //ボタンを有効に
        nextButton.isUserInteractionEnabled = true
        nextButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        nextButton.backgroundColor = ColorPalette.meepleColor()
    }
}
