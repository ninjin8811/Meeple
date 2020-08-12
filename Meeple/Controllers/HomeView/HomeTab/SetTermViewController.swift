//
//  SetTermViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/04/11.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import InstantSearchClient

//MARK:　-　詳細条件設定画面Protocol
protocol SetTermDetailViewDelegate: class {
    func resetTermDetail()
    func setTermDetail(selectedTermList: [Int])
}

class SetTermViewController: UIViewController {
    
    @IBOutlet weak var checkBlockView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var crossImageView: UIImageView!
    
    //検索条件リスト
    static var termLists = [SelectedProfileData]()
    //2人合致の条件で探すかのBool値
    private static var isTwoPepleChecked = false
    
    let dcModel = DCModel()
    private var pickerView: UIPickerView!
    private let pickerViewHeight: CGFloat = 230
    //ピッカービューの上にのせるtoolbar
    private var pickerToolbar: UIToolbar!
    private let toolbarHeight: CGFloat = 40.0
    //選択中のインデックスパス（初期値）
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //デザインを整える
        prepareDesign()
        //テーブルビューに載せるリストを作成
        if SetTermViewController.termLists.isEmpty {
            SetTermViewController.termLists = UserSelectData.termLists()
        }
        tableview.reloadData()
    }
    
    func prepareDesign() {
        //テーブルビューの設定
        tableview.register(SetTermTableViewCell.nib(), forCellReuseIdentifier: "setTermCell")
        tableview.isScrollEnabled = false
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        //画面下ボタンの設定
        resetButton.layer.cornerRadius = 25
        searchButton.layer.cornerRadius = 25
        //右上バツボタンの設定
        crossImageView.isUserInteractionEnabled = true
        crossImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(crossImageViewTapped(_:))))
        //チェックマークviewの設定
        checkImageView.highlightedImage = #imageLiteral(resourceName: "checked-105")
        checkImageView.isHighlighted = SetTermViewController.isTwoPepleChecked
        checkBlockView.isUserInteractionEnabled = true
        checkBlockView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkBlockTapped(_:))))
        //ピッカービューの設定
        pickerView = UIPickerView(frame:CGRect(x: 0, y: self.view.frame.height + toolbarHeight, width: self.view.frame.width, height: pickerViewHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white
        self.view.addSubview(pickerView)
        //ピッカービュー上部の設定
        pickerToolbar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: toolbarHeight))
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        space.width = 10
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancelTapped(_:)))
        let doneButton = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(doneTapped(_:)))
        pickerToolbar.backgroundColor = ColorPalette.lightTextColor()
        cancelButton.tintColor = ColorPalette.meepleColor()
        doneButton.tintColor = ColorPalette.meepleColor()
        pickerToolbar.items = [space, cancelButton, flexible, doneButton, space]
        pickerToolbar.isUserInteractionEnabled = true
        self.view.addSubview(pickerToolbar)
    }
    
    func addGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignPickerView(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        resetTerm()
    }
    
    //MARK:- Algoliaからユーザーを検索
    @IBAction func searchButtonPressed(_ sender: Any) {
        DCModel.userList.removeAll()
        DCModel.userObjectIDList.removeAll()
        DCModel.loadable = true
        setAlgoliaFilter()
        SVProgressHUD.show()
        dcModel.searchUserAlgolia { (isFetched) in
            if isFetched == false {
                print("ユーザーの検索に失敗：setTermView")
            }
            SVProgressHUD.dismiss()
            self.dismiss(animated: true, completion: nil)
        }
    }

    func setAlgoliaFilter() {
        var filter = ""
        //それぞれの年齢（範囲指定）
        if !SetTermViewController.termLists[0].setArray.isEmpty && SetTermViewController.termLists[0].setArray.count == 2 {
            filter += filter.isEmpty ? "" : " AND "
            let term = "\(UserSelectData.ageList()[ SetTermViewController.termLists[0].setArray[0]]) TO \(UserSelectData.ageList()[SetTermViewController.termLists[0].setArray[1]])"
            //2人共合致かどちらかで分ける
            if SetTermViewController.isTwoPepleChecked {
                filter += "age1:\(term) AND age2:\(term)"
            } else {
                filter += "(age1:\(term) OR age2:\(term))"
            }
        }
        //それぞれの学年（複数指定）
        if !SetTermViewController.termLists[1].setArray.isEmpty {
            filter += filter.isEmpty ? "" : " AND "
            //2人共合致かどちらかで分ける
            var isFirstItem = true
            if SetTermViewController.isTwoPepleChecked {
                filter += "("
                for selectedValue in SetTermViewController.termLists[1].setArray {
                    filter += isFirstItem ? "" : " OR "
                    filter += "grade1=\(selectedValue)"
                    isFirstItem = false
                }
                filter += ") AND ("
                isFirstItem = true
                for selectedValue in SetTermViewController.termLists[1].setArray {
                    filter += isFirstItem ? "" : " OR "
                    filter += "grade2=\(selectedValue)"
                    isFirstItem = false
                }
                filter += ")"
            } else {
                filter += "("
                isFirstItem = true
                for selectedValue in SetTermViewController.termLists[1].setArray {
                    filter += isFirstItem ? "" : " OR "
                    filter += "grade1=\(selectedValue) OR grade2=\(selectedValue)"
                    isFirstItem = false
                }
                filter += ")"
            }
        }
        //グループの地域（複数指定）
        if !SetTermViewController.termLists[2].setArray.isEmpty {
            filter += filter.isEmpty ? "" : " AND "
            filter += "("
            var isFirstItem = true
            for selectedValue in SetTermViewController.termLists[2].setArray {
                filter += isFirstItem ? "" : " OR "
                filter += "region=\(selectedValue)"
                isFirstItem = false
            }
            filter += ")"
        }
        //それぞれの身長（範囲指定）
        if !SetTermViewController.termLists[3].setArray.isEmpty && SetTermViewController.termLists[3].setArray.count == 2 {
            filter += filter.isEmpty ? "" : " AND "
            //2人共合致かどちらかで分ける
            if SetTermViewController.isTwoPepleChecked {
                let term = "\(UserSelectData.heightList()[SetTermViewController.termLists[3].setArray[0]]) TO \(UserSelectData.heightList()[SetTermViewController.termLists[3].setArray[1]])"
                filter += "height1:\(term) AND height2:\(term)"
            } else {
                let term = "\(UserSelectData.heightList()[SetTermViewController.termLists[3].setArray[0]]) TO \(UserSelectData.heightList()[SetTermViewController.termLists[3].setArray[1]])"
                filter += "(height1:\(term) OR height2:\(term))"
            }
        }
        //グループの性格（複数指定）
        if !SetTermViewController.termLists[4].setArray.isEmpty {
            filter += filter.isEmpty ? "" : " AND "
            filter += "("
            var isFirstItem = true
            for selectedValue in SetTermViewController.termLists[4].setArray {
                filter += isFirstItem ? "" : " OR "
                filter += "syntality=\(selectedValue)"
                isFirstItem = false
            }
            filter += ")"
        }
        //グループのたばこ（1つだけ）
        if !SetTermViewController.termLists[5].setArray.isEmpty {
            filter += filter.isEmpty ? "" : " AND "
            filter += "cigarette=\(SetTermViewController.termLists[5].setArray[0])"
        }
        print(filter)
        DCModel.query.hitsPerPage = 6
        DCModel.query.filters = filter
    }
    
    @objc
    func crossImageViewTapped(_ sender: UITapGestureRecognizer) {
        print("xボタンが押されました")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func checkBlockTapped(_ sender: UITapGestureRecognizer) {
        print("チェックボタンが押されました")
        checkImageView.isHighlighted = !checkImageView.isHighlighted
        SetTermViewController.isTwoPepleChecked = !SetTermViewController.isTwoPepleChecked
    }
    
    @objc
    func resignPickerView(_ sender: UITapGestureRecognizer) {
        print("画面がタップされたからPickerviewを隠す")
        hidePickerView()
    }
    
}

//MARK:- テーブルビューDelegate
extension SetTermViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SetTermViewController.termLists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "setTermCell") as? SetTermTableViewCell {
            cell.termTitleLabel.text = SetTermViewController.termLists[indexPath.row].title
            
            let termList = SetTermViewController.termLists[indexPath.row]
            if !termList.setArray.isEmpty {
                switch indexPath.row {
                case 0:
                    if termList.setArray.count >= 2 {
                        guard let minIndex = termList.setArray.min(), let maxIndex = termList.setArray.max() else {
                            preconditionFailure("最小、最大が見つけられませんでした：cellForRowAt")
                        }
                        cell.selectedTermLabel.text = "\(termList.termArray[minIndex]) 〜 \(termList.termArray[maxIndex])歳"
                    } else {
                        cell.selectedTermLabel.text = "こだわらない"
                    }
                case 3:
                    if termList.setArray.count >= 2 {
                        guard let minIndex = termList.setArray.min(), let maxIndex = termList.setArray.max() else {
                            preconditionFailure("最小、最大が見つけられませんでした：cellForRowAt")
                        }
                        cell.selectedTermLabel.text = "\(termList.termArray[minIndex]) 〜 \(termList.termArray[maxIndex])cm"
                    } else {
                        cell.selectedTermLabel.text = "こだわらない"
                    }
                case 5:
                    cell.selectedTermLabel.text = "\(termList.termArray[termList.setArray[0]])"
                default:
                    if termList.setArray.count == 1 {
                        cell.selectedTermLabel.text = "\(termList.termArray[termList.setArray[0]])"
                    } else {
                        guard let minIndex = termList.setArray.min() else {
                            preconditionFailure("最小値が見つかりませんでした：cellForRowAt")
                        }
                        cell.selectedTermLabel.text = "\(termList.termArray[minIndex]) ..."
                    }
                }
                cell.selectedTermLabel.textColor = ColorPalette.meepleColor()
                cell.rightArrowImageView.isHighlighted = true
            } else {
                cell.selectedTermLabel.text = "こだわらない"
                cell.selectedTermLabel.textColor = ColorPalette.lightTextColor()
                cell.rightArrowImageView.isHighlighted = false
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath
        if selectedIndexPath.row == 1 || selectedIndexPath.row == 2 || selectedIndexPath.row == 4 {
            //居住地か性格がタップされたとき
            performSegue(withIdentifier: "goToSetTermDetail", sender: self)
        } else {
            //pickerviewを選択する前に一度更新してpickerviewの列数と内容を決める
            pickerView.reloadAllComponents()
            //ピッカービューを選択した状態で更新して表示
            switch indexPath.row {
            case 0, 3:
                if !SetTermViewController.termLists[indexPath.row].setArray.isEmpty && SetTermViewController.termLists[indexPath.row].setArray.count >= 2 {
                    guard let leftIndexRow = SetTermViewController.termLists[indexPath.row].setArray.min(), let rightIndexRow = SetTermViewController.termLists[indexPath.row].setArray.max() else {
                        preconditionFailure("選択済みの条件が見つかりませんでした：didSelectRowAt")
                    }
                    pickerView.selectRow(leftIndexRow, inComponent: 0, animated: false)
                    pickerView.selectRow(rightIndexRow, inComponent: 1, animated: false)
                } else {
                    pickerView.selectRow(0, inComponent: 0, animated: false)
                    pickerView.selectRow(0, inComponent: 1, animated: false)
                    SetTermViewController.termLists[indexPath.row].setArray.append(0)
                    SetTermViewController.termLists[indexPath.row].setArray.append(0)
                }
            case 5:
                if !SetTermViewController.termLists[indexPath.row].setArray.isEmpty {
                    pickerView.selectRow(SetTermViewController.termLists[indexPath.row].setArray[0], inComponent: 0, animated: false)
                } else {
                    pickerView.selectRow(0, inComponent: 0, animated: false)
                    SetTermViewController.termLists[indexPath.row].setArray.append(0)
                }
            default:
                pickerView.selectRow(0, inComponent: 0, animated: false)
            }
            //もう一度更新して選択した状態にする
            pickerView.reloadAllComponents()
            showPickerView()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? SetTermDetailViewController {
            //詳細条件設定画面に条件の名前リストと選択リストを渡す
            if let stringTermList = SetTermViewController.termLists[selectedIndexPath.row].termArray as? [String] {
                destinationVC.stringTermList = stringTermList
            } else {
                destinationVC.stringTermList = ["もう一度選択してください"]
            }
            destinationVC.termTitle = SetTermViewController.termLists[selectedIndexPath.row].title
            destinationVC.selectedIndexList = SetTermViewController.termLists[selectedIndexPath.row].setArray
            destinationVC.delegate = self
        }
    }
}

//MARK:- ピッカービューDelegate
extension SetTermViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if selectedIndexPath.row == SetTermViewController.termLists.count - 1 {
            return 1
        } else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SetTermViewController.termLists[selectedIndexPath.row].termArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Hiragino Sans", size: 16)
        switch selectedIndexPath.row {
        case 0:
            if let termText = SetTermViewController.termLists[selectedIndexPath.row].termArray[row] as? Int {
                label.text = "\(termText)歳"
            }
        case 3:
            if let termText = SetTermViewController.termLists[selectedIndexPath.row].termArray[row] as? Int {
                label.text = "\(termText)cm"
            }
        case 5:
            if let termText = SetTermViewController.termLists[selectedIndexPath.row].termArray[row] as? String {
                label.text = termText
            }
        default:
            label.text = "default"
        }
        //年齢と身長の列に「〜」をつける
        if selectedIndexPath.row == 0 || selectedIndexPath.row == 3 {
            if component == 0 {
                label.text?.append(contentsOf: " 〜")
            } else if let tempText = label.text {
                label.text = "〜 \(tempText)"
            }
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let termList = SetTermViewController.termLists[selectedIndexPath.row]
        if termList.setArray.isEmpty || termList.setArray.count < 2 {
            termList.setArray.append(0)
            termList.setArray.append(0)
        }
        
        switch selectedIndexPath.row {
        case 0, 3:
            if component == 0 {
                termList.setArray[0] = row
            }
            if component == 1 {
                termList.setArray[1] = row
            }
            if termList.setArray[0] > termList.setArray[1] {
                let temp = termList.setArray[0]
                termList.setArray[0] = termList.setArray[1]
                termList.setArray[1] = temp
            }
        case 5:
            termList.setArray.removeAll()
            termList.setArray.append(row)
        default:
            print("デフォルト（エラー）：didSelectRow")
        }
    }
    
    @objc
    func doneTapped(_ sender: UIBarButtonItem) {
        tableview.reloadData()
        hidePickerView()
    }
    
    @objc
    func cancelTapped(_ sender: UIBarButtonItem) {
        SetTermViewController.termLists[selectedIndexPath.row].setArray.removeAll()
        tableview.reloadData()
        hidePickerView()
    }
    
    func showPickerView() {
        //ピッカービューを表示
        UIView.animate(withDuration: 0.2) {
            self.pickerToolbar.frame.origin.y = self.view.frame.height - self.pickerViewHeight - self.toolbarHeight
            self.pickerView.frame.origin.y = self.view.frame.height - self.pickerViewHeight
        }
    }
    
    func hidePickerView() {
        //ピッカービューを隠す
        UIView.animate(withDuration: 0.2) {
            self.pickerToolbar.frame.origin.y = self.view.frame.height
            self.pickerView.frame.origin.y = self.view.frame.height + self.toolbarHeight
            self.tableview.contentOffset.y = 0
        }
    }
    
    func resetTerm() {
        for cell in tableview.visibleCells {
            if let termCell = cell as? SetTermTableViewCell {
                termCell.selectedTermLabel.text = "こだわらない"
                termCell.selectedTermLabel.textColor = ColorPalette.lightTextColor()
                termCell.rightArrowImageView.isHighlighted = false
            }
            for termList in SetTermViewController.termLists {
                termList.setArray.removeAll()
            }
        }
    }
}

//MARK:- 詳細条件設定画面のDelegate
extension SetTermViewController: SetTermDetailViewDelegate {
    //selectedIndexPathは画面遷移から更新されていない
    func resetTermDetail() {
        SetTermViewController.termLists[selectedIndexPath.row].setArray.removeAll()
        if let cell = tableview.cellForRow(at: selectedIndexPath) as? SetTermTableViewCell {
            cell.selectedTermLabel.text = "こだわらない"
            cell.selectedTermLabel.textColor = ColorPalette.lightTextColor()
            cell.rightArrowImageView.isHighlighted = false
        }
    }
    
    func setTermDetail(selectedTermList: [Int]) {
        SetTermViewController.termLists[selectedIndexPath.row].setArray = selectedTermList
        if let cell = tableview.cellForRow(at: selectedIndexPath) as? SetTermTableViewCell {
            if selectedTermList.count == 1 {
                let termIndex = selectedTermList[0]
                cell.selectedTermLabel.text = "\(SetTermViewController.termLists[selectedIndexPath.row].termArray[termIndex])"
            } else {
                guard let termIndex = selectedTermList.min() else {
                    preconditionFailure("最小値が見つかりませんでした")
                }
                cell.selectedTermLabel.text = "\(SetTermViewController.termLists[selectedIndexPath.row].termArray[termIndex]) ..."
            }
            cell.selectedTermLabel.textColor = ColorPalette.meepleColor()
            cell.rightArrowImageView.isHighlighted = true
        }
    }
}
