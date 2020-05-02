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
    
    let dcModel = DCModel()
    //ピッカービュー
    private var pickerView: UIPickerView!
    private let pickerViewHeight: CGFloat = 230
    //ピッカービューの上にのせるtoolbar
    private var pickerToolbar: UIToolbar!
    private let toolbarHeight: CGFloat = 40.0
    //検索条件リスト
    var termLists = [DetailProfileData]()
    //選択中のインデックスパス（初期値）
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    //選択されたpickerviewのインデックス
    var rightSelectedRow = 0
    var leftSelectedRow = 0
    var selectedRow: Int?
    //2人合致の条件で探すかのBool値
    private static var isTwoPepleChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //デザインを整える
        prepareDesign()
        //テーブルビューに載せるリストを作成
        termLists = UserSelectData.termLists()
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
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        if sendTerm() {
            self.dismiss(animated: true, completion: nil)
        } else {
            //失敗アラートを出す
            print("失敗：searchButtonPressed")
        }
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
    
    
    //MARK:- Firestoreに送る条件を設定
    func sendTerm() -> Bool {
        var isSuccess = false
        //UserDefaultsから性別データを取得
        let genderData = UserSelectData.selectedGenderString()
        guard let yourGender = genderData["yourGender"] as? String else {
            preconditionFailure("UserDefaultsにgenderDataが存在しませんでした")
        }
        //暫定のドキュメントパスを用意してクエリを作成
        var ref1 = Firestore.firestore().collection("users").document(yourGender).collection("two") as Query
        var ref2 = Firestore.firestore().collection("users").document(yourGender).collection("two") as Query
        for termList in termLists {
            if termList.setArray.isEmpty == false {
                for term in termList.setArray {
                    //1人目の検索クエリ
                    let tempRef1 = ref1.whereField(termList.fieldArray[0], isEqualTo: term)
                    ref1 = tempRef1
                    //2人目の検索クエリ
                    if termList.fieldArray.count == 2 {
                        let tempRef2 = ref2.whereField(termList.fieldArray[1], isEqualTo: term)
                        ref2 = tempRef2
                    } else {
                        let tempRef2 = ref2.whereField(termList.fieldArray[0], isEqualTo: term)
                        ref2 = tempRef2
                    }
                }
            }
        }
        SVProgressHUD.show()
        dcModel.searchUserFirestore(query: ref1) { (isFetched1) in
            if isFetched1 == false {
                print("ユーザーの検索に失敗：setTermView")
            } else {
                self.dcModel.searchUserFirestore(query: ref2) { (isFetched2) in
                    if isFetched2 == false {
                        print("ユーザーの検索に失敗：setTermView")
                    } else {
                        isSuccess = true
                    }
                }
            }
            SVProgressHUD.dismiss()
        }
        return isSuccess
    }
    
}

//MARK:- テーブルビューDelegate
extension SetTermViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return termLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "setTermCell") as? SetTermTableViewCell {
            cell.termTitleLabel.text = termLists[indexPath.row].title
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //完了ボタンの処理のためにselectedRowはnilにしておく
        selectedRow = nil
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
                if termLists[indexPath.row].setArray.isEmpty == false {
                    leftSelectedRow = termLists[indexPath.row].setArray[0]
                    rightSelectedRow = termLists[indexPath.row].setArray[1]
                    pickerView.selectRow(leftSelectedRow, inComponent: 0, animated: false)
                    pickerView.selectRow(rightSelectedRow, inComponent: 1, animated: false)
                } else {
                    pickerView.selectRow(0, inComponent: 0, animated: false)
                    pickerView.selectRow(0, inComponent: 1, animated: false)
                    leftSelectedRow = 0
                    rightSelectedRow = 0
                }
            case 5:
                if termLists[indexPath.row].setArray.isEmpty == false {
                    pickerView.selectRow(termLists[indexPath.row].setArray[0], inComponent: 0, animated: false)
                    selectedRow = termLists[indexPath.row].setArray[0]
                } else {
                    pickerView.selectRow(0, inComponent: 0, animated: false)
                    selectedRow = 0
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
            if let stringTermList = termLists[selectedIndexPath.row].termArray as? [String] {
                destinationVC.stringTermList = stringTermList
            } else {
                destinationVC.stringTermList = ["もう一度選択してください"]
            }
            destinationVC.termTitle = termLists[selectedIndexPath.row].title
            destinationVC.selectedIndexList = termLists[selectedIndexPath.row].setArray
            destinationVC.delegate = self
        }
    }
}

//MARK:- ピッカービューDelegate
extension SetTermViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if selectedIndexPath.row == termLists.count - 1 {
            return 1
        } else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return termLists[selectedIndexPath.row].termArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Hiragino Sans", size: 16)
        switch selectedIndexPath.row {
        case 0:
            if let termText = termLists[selectedIndexPath.row].termArray[row] as? Int {
                label.text = "\(termText)歳"
            }
        case 3:
            if let termText = termLists[selectedIndexPath.row].termArray[row] as? Int {
                label.text = "\(termText)cm"
            }
        case 5:
            if let termText = termLists[selectedIndexPath.row].termArray[row] as? String {
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
        switch selectedIndexPath.row {
        case 0, 3:
            if component == 0 {
                leftSelectedRow = row
            } else if component == 1 {
                rightSelectedRow = row
            }
            selectedRow = nil
        case 5:
            selectedRow = row
        default:
            print("デフォルト")
        }
        
    }
    
    @objc
    func doneTapped(_ sender: UIBarButtonItem) {
        setTerm()
        hidePickerView()
    }
    
    @objc
    func cancelTapped(_ sender: UIBarButtonItem) {
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
    
    //完了ボタンが押されたときに呼ばれた
    func setTerm() {
        if let cell = tableview.cellForRow(at: selectedIndexPath) as? SetTermTableViewCell {
            //1列と2列のときに条件を分けてセルのラベルを変える処理
            if let row = selectedRow {
                guard let termString = termLists[selectedIndexPath.row].termArray[row] as? String else {
                    preconditionFailure("文字列に変換できませんでした：setTerm")
                }
                cell.selectedTermLabel.text = termString
                //配列をクリアしてから条件リストを作成
                termLists[selectedIndexPath.row].setArray.removeAll()
                termLists[selectedIndexPath.row].setArray.append(row)
            } else {
                if leftSelectedRow > rightSelectedRow {
                    let temp = leftSelectedRow
                    leftSelectedRow = rightSelectedRow
                    rightSelectedRow = temp
                }
                let leftTerm = termLists[selectedIndexPath.row].termArray[leftSelectedRow]
                let rightTerm = termLists[selectedIndexPath.row].termArray[rightSelectedRow]
                switch selectedIndexPath.row {
                case 0:
                    //年齢のとき
                    cell.selectedTermLabel.text = "\(leftTerm) 〜 \(rightTerm)歳"
                case 3:
                    //身長のとき
                    cell.selectedTermLabel.text = "\(leftTerm) 〜 \(rightTerm)cm"
                default:
                    cell.selectedTermLabel.text = "\(leftTerm) 〜 \(rightTerm)"
                }
                //配列をクリアしてから条件リストを作成
                termLists[selectedIndexPath.row].setArray.removeAll()
                termLists[selectedIndexPath.row].setArray.append(leftSelectedRow)
                termLists[selectedIndexPath.row].setArray.append(rightSelectedRow)
            }
            cell.selectedTermLabel.textColor = ColorPalette.meepleColor()
            cell.rightArrowImageView.isHighlighted = true
        } else {
            print("ラベルを変えるセルが見つかりませんでした")
        }
    }
    
    func resetTerm() {
        for cell in tableview.visibleCells {
            if let termCell = cell as? SetTermTableViewCell {
                termCell.selectedTermLabel.text = "こだわらない"
                termCell.selectedTermLabel.textColor = ColorPalette.lightTextColor()
                termCell.rightArrowImageView.isHighlighted = false
            }
            for termList in termLists {
                termList.setArray.removeAll()
            }
        }
    }
}

//MARK:- 詳細条件設定画面のDelegate
extension SetTermViewController: SetTermDetailViewDelegate {
    //selectedIndexPathは画面遷移から更新されていない
    func resetTermDetail() {
        termLists[selectedIndexPath.row].setArray.removeAll()
        if let cell = tableview.cellForRow(at: selectedIndexPath) as? SetTermTableViewCell {
            cell.selectedTermLabel.text = "こだわらない"
            cell.selectedTermLabel.textColor = ColorPalette.lightTextColor()
            cell.rightArrowImageView.isHighlighted = false
        }
    }
    
    func setTermDetail(selectedTermList: [Int]) {
        termLists[selectedIndexPath.row].setArray = selectedTermList
        if let cell = tableview.cellForRow(at: selectedIndexPath) as? SetTermTableViewCell {
            if selectedTermList.count == 1 {
                let termIndex = selectedTermList[0]
                cell.selectedTermLabel.text = "\(termLists[selectedIndexPath.row].termArray[termIndex])"
            } else {
                guard let termIndex = selectedTermList.min() else {
                    preconditionFailure("最小値が見つかりませんでした")
                }
                cell.selectedTermLabel.text = "\(termLists[selectedIndexPath.row].termArray[termIndex]) ..."
            }
            cell.selectedTermLabel.textColor = ColorPalette.meepleColor()
            cell.rightArrowImageView.isHighlighted = true
        }
    }
}
