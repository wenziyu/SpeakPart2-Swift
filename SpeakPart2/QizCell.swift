//
//  QizCell.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/1/19.
//  Copyright © 2019年 com.zoe.SpeakTestHelper. All rights reserved.
//

import UIKit

class QizCell: UICollectionViewCell {
    @IBOutlet weak var qizLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = true
        countLabel.layer.cornerRadius = 20
        countLabel.layer.masksToBounds = true
        qizLabel.font = UIFont(name: "PingFangSC-Semibold", size: Utl.fontSize(size: 22))
        countLabel.font = UIFont(name: "PingFangSC-Semibold", size: Utl.fontSize(size: 15))
    }

}
