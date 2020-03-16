//
//  ProfileImageRegisterViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/04.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit
import Firebase

//MARK:　-　自作クロップビューProtocol
protocol PickProfileImageDelegate: class {
    func endPickingImage(tag: Int, image: UIImage)
}

class ProfileImageRegisterViewController: UIViewController {

    @IBOutlet weak var profileImage1: UIImageView!
    @IBOutlet weak var profileImage2: UIImageView!
    @IBOutlet weak var highlightView1: UIView!
    @IBOutlet weak var highlightView2: UIView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var avatarBlock: UIView!
    
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
        //2人分のアバターブロックのデザイン
        profileImage1.contentMode = .scaleAspectFill
        profileImage2.contentMode = .scaleAspectFill
        profileImage1.image = #imageLiteral(resourceName: "noneAvatar1")
        profileImage2.image = #imageLiteral(resourceName: "noneAvatar2")
        highlightView1.backgroundColor = .clear
        highlightView2.backgroundColor = .clear
        highlightView1.isUserInteractionEnabled = false
        highlightView2.isUserInteractionEnabled = false
        avatarBlock.backgroundColor = ColorPalette.lightTextColor()
        avatarBlock.layer.cornerRadius = 30
        avatarBlock.layer.borderColor = ColorPalette.lightTextColor().cgColor
        avatarBlock.layer.borderWidth = 2
        avatarBlock.layer.masksToBounds = true
        //imageviewにタップ判定をつける
        profileImage1.isUserInteractionEnabled = true
        profileImage2.isUserInteractionEnabled = true
        profileImage1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageview1Tapped(_:))))
        profileImage2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageview2Tapped(_:))))
    }

    //画像のアップロード
    @IBAction func uploadButtonPressed(_ sender: Any) {
        guard let userID = Auth.auth().currentUser?.uid else {
            preconditionFailure("ユーザーIDを取得できませんでした")
        }
        guard let image1 = profileImage1.image else {
            preconditionFailure("ユーザー画像1が存在しませんでした")
        }
        guard let image2 = profileImage2.image else {
            preconditionFailure("ユーザー画像2が存在しませんでした")
        }
        let dcModel = DCModel()
        let storageRef1 = Storage.storage().reference().child("avatarImages/\(userID)1.jpg")
        let storageRef2 = Storage.storage().reference().child("avatarImages/\(userID)2.jpg")
        //アラートの設定
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        //画像の更新を確認してからアップロード
        if isSetImage1 == true && isSetImage2 == true {
            dcModel.uploadProfileImage(tag: 1, image: image1, storageRef: storageRef1) { (isStored1) in
                if isStored1 == false {
                    //アラートを出す
                    alert.title = "画像のアップロードに\n失敗しました"
                    alert.message = "もう一度やり直してください。"
                    self.present(alert, animated: true, completion: nil)
                } else {
                    dcModel.uploadProfileImage(tag: 2, image: image2, storageRef: storageRef2) { (isStored2) in
                        if isStored2 == false {
                            //アラートを出す
                            alert.title = "画像のアップロードに\n失敗しました"
                            alert.message = "もう一度やり直してください。"
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            print("1,2の画像のアップロードに成功しました")
                            self.goToNextView()
                        }
                    }
                }
            }
        } else if isSetImage1 == true {
            //2個設定させるアラートを出す
            alert.title = "2人目の画像が\n設定されていません"
            alert.message = "1人目の画像のみアップロードして\n次へ進みますか？"
            //アラートでOKが押されたときの処理
            let okAction = UIAlertAction(title: "次へ進む", style: .default) { (_) in
                dcModel.uploadProfileImage(tag: 1, image: image1, storageRef: storageRef1) { (isStored) in
                    if isStored == false {
                        //アラートを出す
                        alert.title = "画像のアップロードに\n失敗しました"
                        alert.message = "もう一度やり直してください。"
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        print("1の画像のアップロードに成功しました")
                        self.goToNextView()
                    }
                }
            }
            alert.addAction(okAction)
        } else if isSetImage2 == true {
            //2個設定させるアラートを出す
            alert.title = "1人目の画像が\n設定されていません"
            alert.message = "2人目の画像のみアップロードして\n次へ進みますか？"
            //アラートでOKが押されたときの処理
            let okAction = UIAlertAction(title: "次へ進む", style: .default) { (_) in
                dcModel.uploadProfileImage(tag: 2, image: image2, storageRef: storageRef2) { (isStored) in
                    if isStored == false {
                        alert.title = "画像のアップロードに\n失敗しました"
                        alert.message = "もう一度やり直してください。"
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        print("2の画像アップロードに成功しました")
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
        performSegue(withIdentifier: "goToPersonalityRegister", sender: self)
    }
}


//MARK: - イメージピッカーDelegate
extension ProfileImageRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            switch touch.view {
            case profileImage1:
                highlightView1.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.5)
            case profileImage2:
                highlightView2.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.5)
            default:
                break
            }
        }
    }
    
    @objc
    func imageview1Tapped(_ sender: UITapGestureRecognizer) {
        highlightView1.backgroundColor = .clear
        tag = 1
        pickImage()
    }
    
    @objc
    func imageview2Tapped(_ sender: UITapGestureRecognizer) {
        highlightView2.backgroundColor = .clear
        tag = 2
        pickImage()
    }
    
    func pickImage() {
        print("\(tag)人目の画像設定")
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        //アラートを設定
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
        //アラートを表示
        present(alert, animated: true, completion: nil)
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

//MARK: - 自作クロップビューDelegate
extension ProfileImageRegisterViewController: PickProfileImageDelegate {
    func endPickingImage(tag: Int, image: UIImage) {
        print("\(tag)人目の画像が受け渡されました")
        if tag == 1 {
            profileImage1.image = image
            isSetImage1 = true
        } else {
            profileImage2.image = image
            isSetImage2 = true
        }
        //アップロードボタンを有効にする
        uploadButton.layer.cornerRadius = 25
        uploadButton.setTitleColor(UIColor.white, for: .normal)
        uploadButton.backgroundColor = ColorPalette.meepleColor()
        uploadButton.isUserInteractionEnabled = true
    }
}
