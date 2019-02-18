//
//  WeekCell.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/2/17.
//  Copyright © 2019 com.zoe.SpeakTestHelper. All rights reserved.
//

import UIKit

class WeekCell: UITableViewCell {
    @IBOutlet weak var mon: UIButton!
    @IBOutlet weak var tue: UIButton!
    @IBOutlet weak var wed: UIButton!
    @IBOutlet weak var thu: UIButton!
    @IBOutlet weak var fri: UIButton!
    @IBOutlet weak var sat: UIButton!
    @IBOutlet weak var sun: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mon.layer.cornerRadius = 5
        mon.layer.borderWidth = 1
        mon.titleLabel?.font = UIFont.lightFont(13)
        
        tue.layer.cornerRadius = 5
        tue.layer.borderWidth = 1
        tue.titleLabel?.font = UIFont.lightFont(13)
        
        wed.layer.cornerRadius = 5
        wed.layer.borderWidth = 1
        wed.titleLabel?.font = UIFont.lightFont(13)
        
        thu.layer.cornerRadius = 5
        thu.layer.borderWidth = 1
        thu.titleLabel?.font = UIFont.lightFont(13)
        
        fri.layer.cornerRadius = 5
        fri.layer.borderWidth = 1
        fri.titleLabel?.font = UIFont.lightFont(13)
        
        sat.layer.cornerRadius = 5
        sat.layer.borderWidth = 1
        sat.titleLabel?.font = UIFont.lightFont(13)
        
        sun.layer.cornerRadius = 5
        sun.layer.borderWidth = 1
        sun.titleLabel?.font = UIFont.lightFont(13)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
