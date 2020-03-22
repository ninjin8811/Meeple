//
//  RegisterTableViewCell.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/01/21.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class RegisterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "RegisterTableViewCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
