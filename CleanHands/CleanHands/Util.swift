//
//  Util.swift
//  CleanHands
//
//  Created by ihavebrave on 2021/06/01.
//

import Foundation

let DAY_OF_WEEK_EN
    = ["Monday", "Tuesday", "Wendnesday", "Thursday", "Friday", "Saturday", "Sunday"]
let DAY_OF_WEEK  = ["월", "화", "수", "목", "금", "토", "일"]


func dateToDayOfWeek(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let dayOfTheWeekString = dateFormatter.string(from: date)
    switch dayOfTheWeekString {
        case DAY_OF_WEEK_EN[0]:
            return DAY_OF_WEEK[0]
            
        case DAY_OF_WEEK_EN[1]:
            return DAY_OF_WEEK[1]
            
        case DAY_OF_WEEK_EN[2]:
            return DAY_OF_WEEK[2]
            
        case DAY_OF_WEEK_EN[3]:
            return DAY_OF_WEEK[3]
            
        case DAY_OF_WEEK_EN[4]:
            return DAY_OF_WEEK[4]
            
        case DAY_OF_WEEK_EN[5]:
            return DAY_OF_WEEK[5]
            
        case DAY_OF_WEEK_EN[6]:
            return DAY_OF_WEEK[6]
            
        default:
            return "error"
    }
}


