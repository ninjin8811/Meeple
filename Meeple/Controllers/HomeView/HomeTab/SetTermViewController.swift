//
//  SetTermViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/04/11.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class SetTermViewController: UIViewController {
    
    @IBOutlet weak var checkBlockView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var crossImageView: UIImageView!
    
    //ピッカービュー
    private var pickerView: UIPickerView!
    private let pickerViewHeight: CGFloat = 230
    //pickerViewの上にのせるtoolbar
    private var pickerToolbar: UIToolbar!
    private let toolbarHeight: CGFloat = 40.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //デザインを整える
        prepareDesign()
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
        pickerView = UIPickerView(frame:CGRect(x: 0, y: self.view.frame.height + toolbarHeight,
                                               width: self.view.frame.width, height: pickerViewHeight))
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
        self.view.addSubview(pickerToolbar)
    }

    @IBAction func resetButtonPressed(_ sender: Any) {
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
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
    }
    
}

//MARK:- テーブルビューDelegate
extension SetTermViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "setTermCell") as? SetTermTableViewCell {
            //ここにセルの設定書く
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showPickerView()
    }
}

//MARK:- ピッカービューDelegate
extension SetTermViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    @objc
    func doneTapped(_ sender: UIBarButtonItem) {
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
}
