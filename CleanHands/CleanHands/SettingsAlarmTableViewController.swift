//
//  SettingsAlarmTableViewController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/06/09.
//

import UIKit

class SettingsAlarmTableViewController: UITableViewController {
    
    var isAlarmOn = false
    var isDoNotDisturbOn = false
    
    var isAlarmOnIndexPath: IndexPath?
    var isDoNotDisturbIndexPath: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return 1 + (isAlarmOn ? (isDoNotDisturbOn ? 4 : 2) : 0)
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "isAlarmCell", for: indexPath)
            isAlarmOnIndexPath = indexPath
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "repeatCell", for: indexPath)
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "isDoNotDisturbCell", for: indexPath)
            isDoNotDisturbIndexPath = indexPath
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "fromTimePickerCell", for: indexPath)
            return cell
        }
        // indexPath.row == 4
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toTimePickerCell", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row > 0 && isAlarmOn == false {
            return 0.0  // collapsed
        }
        
        if indexPath.row > 2 && isDoNotDisturbOn == false {
            return 0.0
        }
        
        // expanded with row height of parent
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    @IBAction func alarmSwitchChanged(_ sender: UISwitch) {
        isAlarmOn = sender.isOn
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func doNotDisturbSwitchChanged(_ sender: UISwitch) {
        isDoNotDisturbOn = sender.isOn
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

class IsAlarmCell: UITableViewCell {
    // 알람 온 오프
    @IBOutlet weak var alarmLeadingImage: UIImageView!
    @IBOutlet weak var alarmTitleLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
}

class RepeatCell: UITableViewCell {
    // 클릭시 모달
    @IBOutlet weak var repeatLeadingImage: UIImageView!
    @IBOutlet weak var repeatTitleLabel: UILabel!
    @IBOutlet weak var repeatConfigLabel: UILabel!
    @IBOutlet weak var repeatTrailingImage: UIImageView!
}

class IsDoNotDisturbCell: UITableViewCell {
    // 방해금지모드
    @IBOutlet weak var doNotDisturbLabel: UILabel!
    @IBOutlet weak var doNotDisturbSwitch: UISwitch!
}

class fromTimePickerCell: UITableViewCell {
    // 시작시간 설정
    @IBOutlet weak var fromTimePicker: UIDatePicker!
}

class toTimePickerCell: UITableViewCell {
    // 종료시간 설정
    @IBOutlet weak var toTimePicker: UIDatePicker!
}
