//
//  QuestionList.swift
//  SpeakPart2
//
//  Created by 溫芷榆 on 2019/1/19.
//  Copyright © 2019年 com.zoe.SpeakTestHelper. All rights reserved.
//

import Foundation

struct QuestionList {
    
    var qustopic: String!
    var qustCd: String!
    var question: [Question]!
    
    init() {
    }
}
struct Question {
    
    var quesNo: String!
    var Hint: String!
    var question: String!
    var qustopic: String!
    
    init() {
    }
}
