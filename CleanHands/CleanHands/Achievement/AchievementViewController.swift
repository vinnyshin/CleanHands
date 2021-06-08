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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        achievementTableView.delegate = self
        achievementTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        achievementTableView.reloadData()
    }
    

}
extension AchievementViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AchievementManager.achievements.appearedAchievements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "achievementCell", for: indexPath) as! AchievementCell
        
        let achievement = AchievementManager.achievements.appearedAchievements[indexPath.row]
        cell.item = achievement
        
        return cell
    }
}

class AchievementCell:UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    var item:Achievement? {
        didSet {
            nameLabel.text = item?.name
            descLabel.text = item?.description
        }
    }
}
