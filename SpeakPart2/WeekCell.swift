//
//  WeekCell.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/2/17.
//  Copyright © 2019 com.zoe.SpeakTestHelper. All rights reserved.
//

import UIKit

class WeekCell: UITableViewCell {
    @IBOutlet var WeekBtnArr: [UIButton]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for item in WeekBtnArr {
            item.layer.borderWidth = 1
            item.layer.borderColor = UIColor.black.cgColor
            item.titleLabel?.textColor = UIColor.black
            item.titleLabel?.font = UIFont.lightFont(13)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
