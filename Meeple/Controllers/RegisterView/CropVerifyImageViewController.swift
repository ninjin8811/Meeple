//
//  CropVerifyImageViewController.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/03/17.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class CropVerifyImageViewController: UIViewController {
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var cropFrameView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func completeButtonPressed(_ sender: Any) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
    }
}
