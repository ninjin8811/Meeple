//
//  HomeCollectionViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/19.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

protocol SearchBarDelegate: class {
    func searchBarTapped()
    func sortImageViewTapped()
}

private let reuseIdentifier = "homeUserCell"

class HomeCollectionViewController: UICollectionViewController {
    
    let dcModel = DCModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //見た目を整える
        prepareDesign()
        self.collectionView.register(UserCollectionViewCell.nib(), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(HomeTabHeaderCollectionReusableView.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeTabHeaderCollectionReusableView.identifier)
    }
    
    //とりあえず全ユーザーデータ取得
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dcModel.fetchHomeUserData { (isFetched) in
            if isFetched == false {
                print("ユーザーデータの取得に失敗：HomeCollectionView")
            } else {
                print("ユーザーデータの取得に成功：HomeCollectionView")
                self.collectionView.reloadData()
            }
        }
    }
    
    func prepareDesign() {
        //コレクションビューのレイアウトの設定
        let collectionViewWidth: CGFloat = 160 * 2 + 15
        let paddingLeftRight = (view.bounds.width - collectionViewWidth) / 2
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160, height: 274)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 30, left: paddingLeftRight, bottom: 20, right: paddingLeftRight)
        collectionView.collectionViewLayout = layout
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DCModel.userList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? UserCollectionViewCell {
            //セルの設定を書く
            return UserCollectionViewCell.homeCell(cell: cell, indexPath: indexPath)
        }
        return UICollectionViewCell()
    }
    

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "homeTabHeader", for: indexPath) as? HomeTabHeaderCollectionReusableView {
                headerView.isUserInteractionEnabled = true
                headerView.delegate = self
                return headerView
            }
        }
        return UICollectionReusableView()
    }
    
    //セルがタップされたときのハイライト
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? UserCollectionViewCell {
            cell.highlightView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.5)
        }
    }
    //セルのタップが終わったときのハイライトを消す処理
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? UserCollectionViewCell {
            cell.highlightView.backgroundColor = .clear
        }
    }
    
    
}

//MARK:- さがすヘッダーのDelegate
extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
    //ヘッダーの横幅と高さ指定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 66)
    }
}

extension HomeCollectionViewController: SearchBarDelegate {
    func searchBarTapped() {
        print("サーチバーがタップされました")
        performSegue(withIdentifier: "goToSetTerm", sender: self)
    }
    func sortImageViewTapped() {
        print("ソートイメージがタップされました")
        //メニューアラートを設定
        let alert = UIAlertController(title: "どの順に並び替えますか？", message: "", preferredStyle: .actionSheet)
        let sortReccomendedAction = UIAlertAction(title: "おすすめ順", style: .default) { _ in
            print("おすすめ順がタップされました")
        }
        let sortLatestLoginAction = UIAlertAction(title: "ログインが新しい順", style: .default) { _ in
            print("ログインが新しい順がタップされました")
        }
        let sortLikeAction = UIAlertAction(title: "いいねが多い順", style: .default) { _ in
            print("いいねが多い順がタップされました")
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(sortReccomendedAction)
        alert.addAction(sortLatestLoginAction)
        alert.addAction(sortLikeAction)
        alert.addAction(cancelAction)
        //メニューアラートを表示
        present(alert, animated: true, completion: nil)
    }
    
}
