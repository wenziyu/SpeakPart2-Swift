//
//  TopicCell.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/1/24.
//  Copyright © 2019年 com.zoe.SpeakTestHelper. All rights reserved.
//

import UIKit

class TopicCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = true
        topicLabel.font = UIFont.regularFont(15)
        
        countLabel.layer.cornerRadius = 7.5
        countLabel.layer.masksToBounds = true
        countLabel.font = UIFont.regularFont(10)
        
    }

}
