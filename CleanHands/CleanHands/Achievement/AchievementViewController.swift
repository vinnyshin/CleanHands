//
//  AchievementViewController.swift
//  CleanHands
//
//  Created by hwangguk on 2021/06/08.
//

import UIKit

class AchievementViewController: UIViewController {
    @IBOutlet weak var achieveSegment: UISegmentedControl!
    @IBOutlet weak var achievementTableView: UITableView!
    
    var isOpened: [Bool]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = .black
        achievementTableView.tableFooterView = UIView()
        achievementTableView.delegate = self
        achievementTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        isOpened = [Bool](repeating: false, count: User.userState.achievementManager.appearedAchievements.count + User.userState.achievementManager.completedAchievements.count)
        achievementTableView.reloadData()
    }
    

}
extension AchievementViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return User.userState.achievementManager.appearedAchievements.count + User.userState.achievementManager.completedAchievements.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isOpened[section]) {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let appearedCount = User.userState.achievementManager.appearedAchievements.count
        var achievement:Achievement
        if (indexPath.section >= appearedCount) {
            achievement = User.userState.achievementManager.completedAchievements[indexPath.section-appearedCount]
        }
        else {
            achievement = User.userState.achievementManager.appearedAchievements[indexPath.section]
        }
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "achievementCell", for: indexPath) as! AchievementCell
            
            cell.item = achievement
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! AchievementDescriptionCell
            
            cell.item = achievement
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) as? AchievementCell else {
//            return
//        }
//        guard let index = tableView.indexPath(for: cell) else {
//            return
//        }
        
        if (indexPath.row == 0) {
            isOpened[indexPath.section] = !isOpened[indexPath.section]
            tableView.reloadSections(IndexSet.init(integer: indexPath.section), with: .fade)
        }
    }
}

class AchievementCell:UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var item:Achievement? {
        didSet {
            nameLabel.text = item?.name
            let textColor = UIColor(red: 25.0 / 255, green: 63.0 / 255, blue: 110.0 / 255, alpha: 1.0)
            
            nameLabel.textColor = textColor
            let attributedHeaderString = NSMutableAttributedString()
                .bold(nameLabel.text!, fontSize: 15)
            nameLabel.attributedText = attributedHeaderString
            
            if item!.completed {
                dateLabel.text = "완료"
            }
            else {
                var userPathogenCount = 0
                var neededPathogenCount = 0
                for (pathogen, number) in item!.completeConditions {
                    neededPathogenCount += number
                    if let count = User.userState.pathogenDic[pathogen] {
                        userPathogenCount += count
                    }
                }
                let completePercetage = Int(Float(userPathogenCount)/Float(neededPathogenCount) * 100)
                dateLabel.text = "\(completePercetage)%"
            }
        }
    }
}
class AchievementDescriptionCell:UITableViewCell {
    @IBOutlet weak var descLabel: UILabel!
    var item:Achievement? {
        didSet{
            var descString = item!.description + "\n"
            for (pathogen, number) in item!.completeConditions {
                var userPathogenCount = 0
                if let count = User.userState.pathogenDic[pathogen] {
                    userPathogenCount = count
                }
                if (userPathogenCount >= number) {
                    userPathogenCount = number
                }
                descString += "\n" + pathogen.name + ": (\(userPathogenCount)/\(number))"
            }
            if (item!.completed) {
                let date = item?.completeDate?.description
                let formatedDate = date?.split(separator: " ")[0]
                let dateString :String = formatedDate?.description ?? ""
                descString += "\n날짜: \(dateString)"
            }
            descLabel.text = descString
        }
    }
}
