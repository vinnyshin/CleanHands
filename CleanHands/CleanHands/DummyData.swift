//
//  DummyData.swift
//  CleanHands
//
//  Created by ihavebrave on 2021/05/06.
//

import Foundation

//병원체
struct Pathogen : Comparable{
    static func < (lhs: Pathogen, rhs: Pathogen) -> Bool {
        return lhs.name == rhs.name
    }
    
    let type: PathogenType
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

extension Pathogen : Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}

enum Frequency {
    case high, medium, low
    
    var toString: String {
        switch self {
        case .high:
            return "상"
        case .medium:
            return "중"
        case .low:
            return "하"
        }
    }
}

enum PathogenType {
    case bacteria // 세균
    case virus    // 바이러스
    case mold     // 곰팡이
}

struct User {
    static var userState = User(name: "initName", pathogenDic: [:], washDataList: [], handState: HandState(lastWashTime: Date(), pathogenAmount: 0), exp: 0)
    
    var name: String
//    var profileImage : String?
    var pathogenDic: [Pathogen: Int]
    var washDataList: [WashData]
    var handState: HandState
    var exp: Int
}

struct WashData{
    let date: Date
    var capturedPathogenDic : [Pathogen : Int]
}

struct HandState{
    var lastWashTime: Date
    var pathogenAmount: Int
}


var dummyPathogen =
    Pathogen(type: PathogenType.bacteria ,name: "살모넬라균"
             ,exp: 10, description: "살모사한테 물리면 걸려요"
             , illnesses: Array<String>(["탈모"]),symptom: "머리빠짐", careMethod: "의사 선생님"
             , location: "황국이 입속", frequency: Frequency.high ,image: "salmonella.png")
var dummyPathogen2 =
    Pathogen(type: PathogenType.bacteria ,name: "살모사"
             ,exp: 10, description: "살모사한테 물리면 걸려요"
             , illnesses: Array<String>(["탈모"]),symptom: "머리빠짐", careMethod: "의사 선생님"
             , location: "황국이 입속", frequency: Frequency.high ,image: "salmonella.png")
var dummyPathogen3 =
    Pathogen(type: PathogenType.bacteria ,name: "살모넬라곤"
             ,exp: 10, description: "살모사한테 물리면 걸려요"
             , illnesses: Array<String>(["탈모"]),symptom: "머리빠짐", careMethod: "의사 선생님"
             , location: "황국이 입속", frequency: Frequency.high ,image: "salmonella.png")
var dummyPathogen4 =
    Pathogen(type: PathogenType.bacteria ,name: "살모넬라간"
             ,exp: 10, description: "살모사한테 물리면 걸려요"
             , illnesses: Array<String>(["탈모"]),symptom: "머리빠짐", careMethod: "의사 선생님"
             , location: "황국이 입속", frequency: Frequency.high ,image: "Pathogen.png")


var dummyPathogenList = [dummyPathogen, dummyPathogen2, dummyPathogen3, dummyPathogen4]

var dummyPathogenDic = [dummyPathogen: 120]
var pathogenAmount = dummyPathogenDic.reduce(0) {$0 + $1.value}

var dummyWashData = WashData(date: Date(), capturedPathogenDic: dummyPathogenDic)


var dummyWashDataList = [dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData,dummyWashData]



var dummyHandState = HandState(lastWashTime: Date(), pathogenAmount: pathogenAmount)

var dummyUser = User(name: "유황국", pathogenDic: dummyPathogenDic, washDataList: dummyWashDataList, handState: dummyHandState, exp: 3)


func generateWashDummies() -> [WashData]{
    var list :[WashData] = []

    for _ in 0...99{
        let temp = arc4random_uniform(21);
        list.append(WashData(date: getPrevDateBy(daysToSub: Int(temp)), capturedPathogenDic: dummyPathogenDic))
        print(temp)

    }
    return list
}

var randomWashList = generateWashDummies()

func generateTestWashDataList() -> [WashData]{
    var list :[WashData] = []

    for i in 0...21{
        list.append(WashData(date: getPrevDateBy(daysToSub: i), capturedPathogenDic: dummyPathogenDic))
    }
    return list
}



var testWashList = generateTestWashDataList()
