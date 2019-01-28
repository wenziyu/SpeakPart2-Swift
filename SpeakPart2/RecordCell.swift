//
//  RecordCell.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/1/25.
//  Copyright © 2019年 com.zoe.SpeakTestHelper. All rights reserved.
//

import UIKit

class RecordCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        questionLabel.font = UIFont.regularFont(17)
        timeLabel.font = UIFont.regularFont(14)
        
        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
