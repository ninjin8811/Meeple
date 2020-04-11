//
//  SetTermTableViewCell.swift
//  Meeple
//
//  Created by 吉野史也 on 2020/04/11.
//  Copyright © 2020 Meeple. All rights reserved.
//

import UIKit

class SetTermTableViewCell: UITableViewCell {

    @IBOutlet weak var termTitleLabel: UILabel!
    @IBOutlet weak var selectedTermLabel: UILabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "SetTermTableViewCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
