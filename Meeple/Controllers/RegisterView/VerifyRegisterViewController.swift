//
//  VerifyRegisterViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/17.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class VerifyRegisterViewController: UIViewController {

    @IBOutlet weak var verifyBlock1: UIView!
    @IBOutlet weak var verifyBlock2: UIView!
    @IBOutlet weak var verifyImage1: UIImageView!
    @IBOutlet weak var verifyImage2: UIImageView!
    @IBOutlet weak var highlightView1: UIView!
    @IBOutlet weak var highlightView2: UIView!
    @IBOutlet weak var uploadButton: UIButton!
    
    var tag = 0
    var isSetImage1 = false
    var isSetImage2 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //見た目を整える
        prepareDesign()
    }
    
    func prepareDesign() {
        //遷移先ナビゲーションバーの戻るボタン
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
        //アップロードボタンが無効時のデザイン
        uploadButton.layer.cornerRadius = 25
        uploadButton.setTitleColor(ColorPalette.textColor(), for: .normal)
        uploadButton.backgroundColor = ColorPalette.disabledColor()
        uploadButton.isUserInteractionEnabled = false
        //1人目の認証画像ブロックのデザイン
        verifyBlock1.layer.cornerRadius = 20
        verifyBlock1.layer.borderColor = ColorPalette.lightTextColor().cgColor
        verifyBlock1.layer.borderWidth = 2
        verifyBlock1.layer.masksToBounds = true
        verifyImage1.contentMode = .scaleAspectFill
        verifyImage1.image = #imageLiteral(resourceName: <#T##String#>)
        highlightView1.backgroundColor = .clear
        highlightView1.isUserInteractionEnabled = false
        verifyImage1.isUserInteractionEnabled = true
        verifyImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(verifyImage1Tapped(_:))))
        //2人目の認証画像ブロックのデザイン
        verifyBlock2.layer.cornerRadius = 20
        verifyBlock2.layer.borderColor = ColorPalette.lightTextColor().cgColor
        verifyBlock2.layer.borderWidth = 2
        verifyBlock2.layer.masksToBounds = true
        verifyImage2.contentMode = .scaleAspectFill
        verifyImage2.image = #imageLiteral(resourceName: <#T##String#>)
        highlightView2.backgroundColor = .clear
        highlightView2.isUserInteractionEnabled = false
        verifyImage2.isUserInteractionEnabled = true
        verifyImage2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(verifyImage2Tapped(_:))))
    }
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
    }
    @IBAction func skipButtonPressed(_ sender: Any) {
    }
}

extension VerifyRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            switch touch.view {
            case verifyImage1:
                highlightView1.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.5)
            case verifyImage2:
                highlightView2.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.5)
            default:
                break
            }
        }
    }
    
    @objc
    func verifyImage1Tapped(_ sender: UITapGestureRecognizer) {
        
    }
    
    @objc
    func verifyImage2Tapped(_ sender: UITapGestureRecognizer) {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //画像が選択されたら編集画面へ移動
        if let image = info[.originalImage] as? UIImage {
            if let cropViewController = self.storyboard?.instantiateViewController(identifier: "goToCrop") as? CropViewController {
                cropViewController.selectedImage = image
                cropViewController.tag = tag
                cropViewController.modalPresentationStyle = .fullScreen
                cropViewController.delegate = self
                self.presentedViewController?.present(cropViewController, animated: true, completion: nil)
            }
        }
    }
}

extension VerifyRegisterViewController: PickProfileImageDelegate {
    func endPickingImage(tag: Int, image: UIImage) {
        
    }
}
