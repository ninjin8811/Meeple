//
//  VerifyRegisterViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/17.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

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
        verifyImage1.image = #imageLiteral(resourceName: "noneVerify1")
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
        verifyImage2.image = #imageLiteral(resourceName: "noneVerify2")
        highlightView2.backgroundColor = .clear
        highlightView2.isUserInteractionEnabled = false
        verifyImage2.isUserInteractionEnabled = true
        verifyImage2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(verifyImage2Tapped(_:))))
    }
    
    //画像のアップロード
    @IBAction func uploadButtonPressed(_ sender: Any) {
        guard let userID = Auth.auth().currentUser?.uid else {
            preconditionFailure("ユーザーIDを取得できませんでした")
        }
        guard let image1 = verifyImage1.image else {
            preconditionFailure("ユーザー画像1が存在しませんでした")
        }
        guard let image2 = verifyImage2.image else {
            preconditionFailure("ユーザー画像2が存在しませんでした")
        }
        let dcModel = DCModel()
        let storageRef1 = Storage.storage().reference().child("verifyImages/\(userID)_verify1.jpg")
        let storageRef2 = Storage.storage().reference().child("verifyImages/\(userID)_verify2.jpg")
        //アラートの設定
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        //画像の更新を確認してからアップロード
        if isSetImage1 == true && isSetImage2 == true {
            SVProgressHUD.show()
            dcModel.uploadVerifyImage(tag: 1, image: image1, storageRef: storageRef1) { (isStored1) in
                if isStored1 == false {
                    //アラートを出す
                    alert.title = "画像のアップロードに\n失敗しました"
                    alert.message = "もう一度やり直してください。"
                    self.present(alert, animated: true, completion: nil)
                    SVProgressHUD.dismiss()
                } else {
                    dcModel.uploadVerifyImage(tag: 2, image: image2, storageRef: storageRef2) { (isStored2) in
                        SVProgressHUD.dismiss()
                        if isStored2 == false {
                            //アラートを出す
                            alert.title = "画像のアップロードに\n失敗しました"
                            alert.message = "もう一度やり直してください。"
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            print("1,2の認証画像のアップロードに成功しました")
                            self.goToNextView()
                        }
                    }
                }
            }
        } else if isSetImage1 == true {
            //2個設定させるアラートを出す
            alert.title = "2人目の学生証が\n設定されていません"
            alert.message = "1人目の学生証のみアップロードして\n次へ進みますか？"
            //アラートでOKが押されたときの処理
            let okAction = UIAlertAction(title: "次へ進む", style: .default) { (_) in
                SVProgressHUD.show()
                dcModel.uploadVerifyImage(tag: 1, image: image1, storageRef: storageRef1) { (isStored) in
                    SVProgressHUD.dismiss()
                    if isStored == false {
                        //アラートを出す
                        alert.title = "画像のアップロードに\n失敗しました"
                        alert.message = "もう一度やり直してください。"
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        print("1の認証画像のアップロードに成功しました")
                        self.goToNextView()
                    }
                }
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else if isSetImage2 == true {
            //2個設定させるアラートを出す
            alert.title = "1人目の学生証が\n設定されていません"
            alert.message = "2人目の学生証のみアップロードして\n次へ進みますか？"
            //アラートでOKが押されたときの処理
            let okAction = UIAlertAction(title: "次へ進む", style: .default) { (_) in
                SVProgressHUD.show()
                dcModel.uploadVerifyImage(tag: 2, image: image2, storageRef: storageRef2) { (isStored) in
                    SVProgressHUD.dismiss()
                    if isStored == false {
                        alert.title = "画像のアップロードに\n失敗しました"
                        alert.message = "もう一度やり直してください。"
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        print("2の認証画像のアップロードに成功しました")
                        self.goToNextView()
                    }
                }
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        goToNextView()
    }
    
    func goToNextView() {
        performSegue(withIdentifier: "goToEndRegister", sender: self)
    }
}

//MARK: - イメージピッカーDelegate
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
        highlightView1.backgroundColor = .clear
        tag = 1
        pickImage()
    }
    
    @objc
    func verifyImage2Tapped(_ sender: UITapGestureRecognizer) {
        highlightView2.backgroundColor = .clear
        tag = 2
        pickImage()
    }
    
    func pickImage() {
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        //メニューアラートを設定
        let alert = UIAlertController(title: "プロフィール画像を選んでください", message: "", preferredStyle: .actionSheet)
        let launchCameraAction = UIAlertAction(title: "カメラを起動", style: .default) { _ in
            pickerView.sourceType = .camera
            self.present(pickerView, animated: true, completion: nil)
        }
        let pickAction = UIAlertAction(title: "カメラロールから選択", style: .default) { _ in
            pickerView.sourceType = .photoLibrary
            self.present(pickerView, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(launchCameraAction)
        alert.addAction(pickAction)
        alert.addAction(cancelAction)
        //メニューアラートを表示
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //画像が選択されたら編集画面へ移動
        if let image = info[.originalImage] as? UIImage {
            if let cropViewController = self.storyboard?.instantiateViewController(identifier: "goToCropVerifyImage") as? CropVerifyImageViewController {
                cropViewController.selectedImage = image
                cropViewController.tag = tag
                cropViewController.modalPresentationStyle = .fullScreen
                cropViewController.delegate = self
                self.presentedViewController?.present(cropViewController, animated: true, completion: nil)
            }
        }
    }
}

//MARK: - 自作クロップビューDelegate
extension VerifyRegisterViewController: PickProfileImageDelegate {
    func endPickingImage(tag: Int, image: UIImage) {
        print("\(tag)人目の画像が受け渡されました")
        if tag == 1 {
            verifyImage1.image = image
            isSetImage1 = true
        } else {
            verifyImage2.image = image
            isSetImage2 = true
        }
        //アップロードボタンを有効にする
        uploadButton.layer.cornerRadius = 25
        uploadButton.setTitleColor(UIColor.white, for: .normal)
        uploadButton.backgroundColor = ColorPalette.meepleColor()
        uploadButton.isUserInteractionEnabled = true
    }
}
