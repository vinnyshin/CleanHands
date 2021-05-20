//
//  DummyData.swift
//  CleanHands
//
//  Created by ihavebrave on 2021/05/06.
//

import Foundation

//병원체
struct Pathogen{
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
    static var userState = User(name: "initName", pathoganList: [], washDataList: [], handState: HandState(lastWashTime: Date(), pathogenAmount: 0), exp: 0)
    
    var name: String
//    var profileImage : String?
    var pathoganList: [Pathogen]
    var washDataList: [WashData]
    var handState: HandState
    var exp: Int
}

struct WashData{
    let date: Date
    var capturedPathogenList : [Pathogen]
}

struct HandState{
    var lastWashTime: Date
    var pathogenAmount: Int
}


var dummyPathogen =
    Pathogen(type: PathoganType.bacteria ,name: "살모넬라균"
             ,exp: 10, description: "살모사한테 물리면 걸려요"
             , illnesses: Array<String>(["탈모"]),symptom: "머리빠짐", careMethod: "의사 선생님"
             , location: "황국이 입속", frequency: Frequency.high ,image: "salmonella.png")




var dummyPathoganList = [dummyPathogen]

var dummyWashData = WashData(date: Date(), capturedPathogenList: dummyPathoganList)

var dummyWashDataList = [dummyWashData]

var dummyHandState = HandState(lastWashTime: Date(), pathogenAmount: dummyPathoganList.count)

var dummyUser = User(name: "유황국", pathoganList: dummyPathoganList, washDataList: dummyWashDataList
                     , handState: dummyHandState, exp: 3)


