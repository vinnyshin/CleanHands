//
//  DummyData.swift
//  CleanHands
//
//  Created by ihavebrave on 2021/05/06.
//

import Foundation

//병원체
struct Pathogan {
    let type: PathoganType
    let name: String
    let exp: Int
    let description: String
    let illnesses : [String]
    let symptom : String
    let careMethod : String
    let location : String
    let frequency : Frequency
    let image : String
}

extension Pathogan : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}

enum Frequency {
    case high
    case medium
    case low
}

enum PathoganType {
    case bacteria // 세균
    case virus    // 바이러스
    case mold     // 곰팡이
}

struct User {
    var name: String
//    var profileImage : String?
    var pathoganDic: [Pathogan: Int]
    var washDataList: [WashData]
    var handState: HandState
    var exp: Int
}

struct WashData{
    let date: [Date]
    var capturedPathoganDic : [Pathogan: Int]
}

struct HandState{
    var lastWashTime: Date
    var pathoganAmount: Int
}


var dummyPathogan =
    Pathogan(type: PathoganType.bacteria ,name: "살모넬라균"
             ,exp: 10, description: "살모사한테 물리면 걸려요"
             , illnesses: Array<String>(["탈모"]),symptom: "머리빠짐", careMethod: "의사 선생님"
             , location: "황국이 입속", frequency: Frequency.high ,image: "salmonella.png")




var dummyPathoganDic = [dummyPathogan: 120]
var pathoganAmount = dummyPathoganDic.reduce(0) {$0 + $1.value}

var dummyWashData = WashData(date: Array<Date>([Date()]), capturedPathoganDic: dummyPathoganDic)

var dummyWashDataList = [dummyWashData]

var dummyHandState = HandState(lastWashTime: Date(), pathoganAmount: pathoganAmount)

var dummyUser = User(name: "유황국", pathoganDic: dummyPathoganDic, washDataList: dummyWashDataList, handState: dummyHandState, exp: 3)


