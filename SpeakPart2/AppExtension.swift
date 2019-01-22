//
//  AppExtension.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/1/19.
//  Copyright © 2019年 com.zoe.SpeakTestHelper. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    static let appYellow = UIColor(red:246/255, green:221/255 ,blue:85/255 , alpha:1.0)
    
}
extension Array {
    /// 安全的 array index，防止 index out of range
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
   
}
