//
//  MenuHeaderCell.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/2/13.
//  Copyright © 2019 com.zoe.SpeakTestHelper. All rights reserved.
//

import UIKit

class MenuHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var title: UILabel!

    
    override func awakeFromNib() {
        title.font = UIFont.lightFont(18)
    }

}
