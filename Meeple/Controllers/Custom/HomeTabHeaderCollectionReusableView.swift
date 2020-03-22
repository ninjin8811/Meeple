//
//  HomeTabHeaderCollectionReusableView.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/20.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class HomeTabHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchMoreImageView: UIImageView!
    @IBOutlet weak var highlightView: UIView!
    
    static let identifier = "homeTabHeader"
    weak var delegate: SearchBarDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //見た目を整える
        prepareDesign()
    }

    static func nib() -> UINib {
        return UINib(nibName: "HomeTabHeaderCollectionReusableView", bundle: nil)
    }
    
    func prepareDesign() {
        //サーチバーの設定
        searchBarView.isUserInteractionEnabled = true
        searchBarView.layer.cornerRadius = 10
        searchBarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchBarViewTapped(_:))))
        //サーチバーの横のアイコンの設定
        searchMoreImageView.isUserInteractionEnabled = true
        searchMoreImageView.image = #imageLiteral(resourceName: "searchMoreIcon")
        searchMoreImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchMoreImageViewTapped(_:))))
        //サーチバーのハイライトビューの設定
        highlightView.isUserInteractionEnabled = false
        highlightView.layer.cornerRadius = 10
        //サーチバー横のアイコンのハイライト設定
        searchMoreImageView.isHighlighted = false
        searchMoreImageView.highlightedImage = #imageLiteral(resourceName: "searchMoreHighlight")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view == searchBarView || touch.view == searchMoreImageView {
                highlightView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.2992829623)
                searchMoreImageView.isHighlighted = true
            }
        }
    }
    
    @objc
    func searchBarViewTapped(_ sender: UITapGestureRecognizer) {
        highlightView.backgroundColor = .clear
        searchMoreImageView.isHighlighted = false
        delegate?.searchBarTapped()
    }
    
    @objc
    func searchMoreImageViewTapped(_ sender: UITapGestureRecognizer) {
        highlightView.backgroundColor = .clear
        searchMoreImageView.isHighlighted = false
        delegate?.searchBarTapped()
    }
    
}
