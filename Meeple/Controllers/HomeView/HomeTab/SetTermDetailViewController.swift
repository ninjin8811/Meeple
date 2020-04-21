//
//  SetTermDetailViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/04/14.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class SetTermDetailViewController: UIViewController {
    
    @IBOutlet weak var kodawaranaiButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var setButton: UIButton!
    
    var termTitle = "タイトル"
    var stringTermList = [String]()
    var selectedIndexList = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //見た目を整える
        prepareDesign()
    }
    
    func prepareDesign() {
        //tableviewの設定
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(RegisterTableViewCell.nib(), forCellReuseIdentifier: "termCell")
        //設定ボタン
        setButton.layer.cornerRadius = 25
        setButton.isUserInteractionEnabled = false
        setButton.setTitleColor(ColorPalette.textColor(), for: .normal)
        setButton.backgroundColor = ColorPalette.disabledColor()
        //タイトルの設定
        titleLabel.text = termTitle
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func kodawaranaiButtonPressed(_ sender: Any) {
    }
    
    @IBAction func setButtonPressed(_ sender: Any) {
    }
    
}

extension SetTermDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stringTermList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(40)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RegisterTableViewCell else {
            preconditionFailure("セルを取得できませんでした：SetTermDetail:didSelectRowAt")
        }
        if let index = selectedIndexList.firstIndex(of: indexPath.row) {
            selectedIndexList.remove(at: index)
            //選択されていたセルがタップされたらデザインを元に戻す
            cell.titleLabel.textColor = ColorPalette.lightTextColor()
            cell.checkmarkImage.image = nil
        } else {
            selectedIndexList.append(indexPath.row)
            //新しく選択されたセルのデザインをチェック済みにする
            cell.titleLabel.textColor = ColorPalette.meepleColor()
            cell.checkmarkImage.image = #imageLiteral(resourceName: "checkmark-60")
        }
        if selectedIndexList.isEmpty {
            //ボタンを無効に
            setButton.isUserInteractionEnabled = false
            setButton.setTitleColor(ColorPalette.textColor(), for: .normal)
            setButton.backgroundColor = ColorPalette.disabledColor()
        } else {
            //ボタンを有効に
            setButton.isUserInteractionEnabled = true
            setButton.setTitleColor(UIColor.white, for: .normal)
            setButton.backgroundColor = ColorPalette.meepleColor()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "termCell") as? RegisterTableViewCell {
            cell.titleLabel.text = stringTermList[indexPath.row]
            cell.titleLabel.textColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
            cell.checkmarkImage.image = nil
            cell.selectionStyle = .none
            return cell
        }
        return RegisterTableViewCell()
    }
    
    
}
