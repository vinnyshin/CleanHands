//
//  DummyData.swift
//  CleanHands
//
//  Created by ihavebrave on 2021/05/06.
//

import Foundation

struct AchievementManager {
    static var achievements = AchievementManager(completedAchievements: [Achievement](), appearedAchievements: [Achievement](), entireAchievements: [Achievement]())
    
    var completedAchievements: [Achievement]
    var appearedAchievements: [Achievement]
    var entireAchievements: [Achievement]
    
    static func initList() {
        achievements.entireAchievements = achievementList
        AchievementManager.updateAchievement()
    }
    
    static func updateAchievement () {
        for achievement in achievements.entireAchievements {
            if (achievement.appeared) {
                achievements.appearedAchievements.append(achievement)
                if let index = achievements.entireAchievements.firstIndex(of: achievement) {
                    achievements.entireAchievements.remove(at: index)
                }
            }
        }
        for achievement in achievements.appearedAchievements {
            if (achievement.completed) {
                achievements.completedAchievements.append(achievement)
                if let index = achievements.appearedAchievements.firstIndex(of: achievement) {
                    achievements.appearedAchievements.remove(at: index)
                }
            }
        }
    }
    static func compeleteButtonPressed() {
        
    }
}

struct Achievement:Equatable {
    let id: Int
    let name: String
    let description: String
    let reward: Int
    let appearConditions: [Achievement]
    let completeConditions: [Pathogen:Int]
    
    var appeared:Bool {
        for achievementCondition in appearConditions {
            if (!AchievementManager.achievements.completedAchievements.contains(achievementCondition)) {
                return false
            }
        }
        return true
    }
    
    var completed: Bool {
        let userPathogenDic = User.userState.pathogenDic
        for (pathogen, number) in self.completeConditions {
            guard let pathogenAmount = userPathogenDic[pathogen] else {
                return false
            }
            if (pathogenAmount < number) {
                return false
            }
        }
        
        return true
    }
    
    init(name:String, description:String, completeConditions:[Pathogen:Int], appearConditions: [Achievement], id:Int) {
        self.name = name
        self.description = description
        self.completeConditions = completeConditions
        self.appearConditions = appearConditions
        self.reward = 0
        self.id = id
    }
    static func == (lhs:Achievement, rhs:Achievement)->Bool {
        return lhs.id == rhs.id
    }
}

//병원체
struct Pathogen : Equatable, Codable{
    static func == (lhs: Pathogen, rhs: Pathogen) -> Bool {
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

enum Frequency :String, Codable{
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

enum PathogenType : Int, Codable{
    case bacteria // 세균
    case virus    // 바이러스
    case mold     // 곰팡이
}

struct User : Codable{
//    static var userState = User(name: "initName", pathogenDic: [:], washDataList: [], handState: HandState(lastWashTime: Date(), pathogenAmount: 0), exp: 0)
    
    static var userState = loadUser()
    
    var name: String
//    var profileImage : String?
    var pathogenDic: [Pathogen: Int]
    var washDataList: [WashData]
    var handState: HandState
    var exp: Int
}

struct WashData : Codable{
    let date: Date
    var capturedPathogenDic : [Pathogen : Int]
}

struct HandState: Codable{
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


var achievement1 = Achievement(name: "살모넬라균 퇴치1", description: "살모넬라균을 50마리 잡으세요.", completeConditions: [dummyPathogen:50], appearConditions: [], id: 0)
var achievement2 = Achievement(name: "살모넬라균 퇴치2", description: "살모넬라균을 150마리 잡으세요.", completeConditions: [dummyPathogen:150], appearConditions: [achievement1], id: 1)
var achievement3 = Achievement(name: "살모넬라균 퇴치3", description: "살모넬라균을 300마리 잡으세요.", completeConditions: [dummyPathogen:300], appearConditions: [achievement2], id: 2)
var achievement4 = Achievement(name: "살모넬라곤 퇴치1", description: "살모넬라곤을 50마리 잡으세요.", completeConditions: [dummyPathogen3:50], appearConditions: [], id: 3)
var achievementList = [achievement1, achievement4, achievement2, achievement3]
