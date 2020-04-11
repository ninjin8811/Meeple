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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //テーブルビューの設定
        tableview.register(SetTermTableViewCell.nib(), forCellReuseIdentifier: "setTermCell")
        tableview.isScrollEnabled = false
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        //デザインを整える
        prepareDesign()
    }
    
    func prepareDesign() {
        //画面下ボタンの設定
        resetButton.layer.cornerRadius = 25
        searchButton.layer.cornerRadius = 25
        //右上バツボタンの設定
        crossImageView.isUserInteractionEnabled = true
        crossImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(crossImageViewTapped(_:))))
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
    
}

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
    
    
}
