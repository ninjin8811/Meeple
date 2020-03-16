//
//  CropViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/12.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit
import AVFoundation

class CropViewController: UIViewController {

    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var cropFrameView: UIView!
    
    var selectedImage: UIImage?
    var tag = 0
    weak var delegate: PickProfileImageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //デザインを整える
        prepareDesign()
    }
    
    func prepareDesign() {
        //cropFrameViewの設定
        cropFrameView.backgroundColor = .clear
        cropFrameView.layer.borderWidth = 2.0
        cropFrameView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cropFrameView.isUserInteractionEnabled = false
        //scrollviewの設定
        scrollview.delegate = self
        if let image = selectedImage {
            scrollview.minimumZoomScale = 1
            scrollview.maximumZoomScale = 5
            scrollview.zoomScale = scrollview.minimumZoomScale
            imageview.image = image
        } else {
            //画像を受け取れていなかった場合、とりあえず編集画面を消す
            dismiss(animated: true, completion: nil)
        }
        updateContentInset()
    }
    
    @IBAction func completeButtonPressed(_ sender: Any) {
        let croppedImage = cropImage()
        if let delegate = self.delegate {
            delegate.endPickingImage(tag: tag, image: croppedImage)
        }
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CropViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageview
    }
    
    func updateContentInset() {
        let heightInset = max((scrollview.frame.height - cropFrameView.frame.height) / 2, 0)
        let widthInset = max((scrollview.frame.width - cropFrameView.frame.width) / 2, 0)
        scrollview.contentInset = UIEdgeInsets(top: heightInset, left: widthInset, bottom: 0, right: 0)
    }
    
    func cropImage() -> UIImage {
        guard let image = selectedImage else {
            preconditionFailure("画像が存在しませんでした（cropImage）")
        }
        //イメージビューに対する画像のスケール比を取得
        let imageViewScale = max(image.size.width / imageview.frame.width, image.size.height / imageview.frame.height)
        //イメージビュー内における画像の位置を取得
        let imageOriginInImageView = AVMakeRect(aspectRatio: image.size, insideRect: imageview.frame).origin
        //画像のクロップ処理
        let cropZone = CGRect(
            x: (scrollview.contentOffset.x - imageOriginInImageView.x) * imageViewScale,
            y: (scrollview.contentOffset.y - imageOriginInImageView.y) * imageViewScale,
            width: cropFrameView.frame.width * imageViewScale,
            height: cropFrameView.frame.height * imageViewScale)
        if let croppedCGImage = image.cgImage?.cropping(to: cropZone) {
            let croppedUIImage = UIImage(cgImage: croppedCGImage)
            print(croppedUIImage.size)
            return croppedUIImage
        } else {
            print("画像のクロップに失敗しました(cropImage)")
        }
        return UIImage()
    }
}
