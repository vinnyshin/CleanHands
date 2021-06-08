

import UIKit

func saveUserState() {
    let documentsDirctory =
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let archiveURL = documentsDirctory.appendingPathComponent("userState").appendingPathExtension("json")
            
    let jsonEncodoer = JSONEncoder()
    var jsonData : Data
    do{
        jsonData = try jsonEncodoer.encode(User.userState)
        try jsonData.write(to: archiveURL)
    }catch{
        print(error)
        return
    }
}

func loadUser() -> User{
    do{
        let documentsDirctory =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirctory.appendingPathComponent("calc_operation").appendingPathExtension("json")
        let jsonDecoder = JSONDecoder()

        var retrievedJsonData : Data
        var decoded :User
        retrievedJsonData = try Data(contentsOf: archiveURL)
        decoded = try jsonDecoder.decode(User.self, from: retrievedJsonData)
        return decoded
    }catch{
        print(error)
        return User(name: "initName", pathogenDic: [:], washDataList: [], handState: HandState(lastWashTime: Date(), pathogenAmount: 0), exp: 0)
    }
    return User(name: "initName", pathogenDic: [:], washDataList: [], handState: HandState(lastWashTime: Date(), pathogenAmount: 0), exp: 0)
}
