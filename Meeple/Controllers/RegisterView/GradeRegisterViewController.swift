//
//  GradeRegisterViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/03.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class GradeRegisterViewController: UIViewController {

    @IBOutlet weak var tableview1: UITableView!
    @IBOutlet weak var tableview2: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    var selectedIndexPath1: IndexPath?
    var selectedIndexPath2: IndexPath?
    let gradeList = UserSelectData.gradeList()
    var tag = 0
    var cellIdentifier = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //見た目を整える
        prepareDesign()
        //テーブルビューの設定
        tableview1.register(UINib(nibName: "RegisterTableViewCell", bundle: nil), forCellReuseIdentifier: "gradeCell1")
        tableview1.isScrollEnabled = false
        tableview1.separatorStyle = .none
        tableview2.register(UINib(nibName: "RegisterTableViewCell", bundle: nil), forCellReuseIdentifier: "gradeCell2")
        tableview2.isScrollEnabled = false
        tableview2.separatorStyle = .none
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
        DCModel.currentUserData.grade1 = selectedIndexPath1?.row
        DCModel.currentUserData.grade2 = selectedIndexPath2?.row
        performSegue(withIdentifier: "goToProfileImageRegister", sender: self)
    }
}

extension GradeRegisterViewController: UITableViewDelegate, UITableViewDataSource {
    
    //テーブルビューを判別
    func checkTableView(_ tableview: UITableView) {
        if tableview.tag == 1 {
            tag = 1
            cellIdentifier = "gradeCell1"
        } else {
            tag = 2
            cellIdentifier = "gradeCell2"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gradeList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(40)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        checkTableView(tableView)
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RegisterTableViewCell {
            cell.titleLabel.text = gradeList[indexPath.row]
            cell.titleLabel.textColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
            cell.checkmarkImage.image = nil
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkTableView(tableView)
        //選択されていたセルのデザインを元に戻す
        if tag == 1 {
            if let deselectIndexPath = selectedIndexPath1 {
                if let deselectCell = tableView.cellForRow(at: deselectIndexPath) as? RegisterTableViewCell {
                    deselectCell.titleLabel.textColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
                    deselectCell.checkmarkImage.image = nil
                } else {
                    print("選択解除するセルのキャストに失敗")
                }
                //新しく選択されたインデックスパスを更新
                selectedIndexPath1 = indexPath
            } else {
                //新しく選択されたインデックスパスを更新
                selectedIndexPath1 = indexPath
            }
        } else {
            if let deselectIndexPath = selectedIndexPath2 {
                if let deselectCell = tableView.cellForRow(at: deselectIndexPath) as? RegisterTableViewCell {
                    deselectCell.titleLabel.textColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
                    deselectCell.checkmarkImage.image = nil
                } else {
                    print("選択解除するセルのキャストに失敗")
                }
                //新しく選択されたインデックスパスを更新
                selectedIndexPath2 = indexPath
            } else {
                //新しく選択されたインデックスパスを更新
                selectedIndexPath2 = indexPath
            }
        }
        //新しく選択されたセルのデザインをチェック済みにする
        if let cell = tableView.cellForRow(at: indexPath) as? RegisterTableViewCell {
            cell.titleLabel.textColor = #colorLiteral(red: 0.8784313725, green: 0.4, blue: 0.3450980392, alpha: 1)
            cell.checkmarkImage.image = #imageLiteral(resourceName: "checkmark-60")
        } else {
            print("選択したセルのキャストに失敗")
        }
        //2つとも選択されていたらボタンを有効にする
        if selectedIndexPath1 != nil && selectedIndexPath2 != nil {
            nextButton.isUserInteractionEnabled = true
            nextButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            nextButton.backgroundColor = ColorPalette.meepleColor()
        }
    }
}
