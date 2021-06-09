//
//  SettingsAlarmTableViewController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/06/09.
//

import UIKit
import UserNotifications

class SettingsAlarmTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var isAlarmOn = false
    var isDoNotDisturbOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter
        .requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            if !granted {
                print("User has declined notifications")
            }
        }
        
        notificationCenter.getNotificationSettings {
            (settings) in
              if settings.authorizationStatus != .authorized {
                // Notifications not allowed
              }
        }
    }
    
    
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "손이 더러워요!"
        content.body = "손을 안씻은지 오래됐어요! 손을 씻어주새요."
        content.categoryIdentifier = "alarm"
//        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        // time interval을 바꾸면 가능
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)


        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo

        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")

            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")

            case "show":
                // the user tapped our "show more info…" button
                print("Show more information…")
                break

            default:
                break
            }
        }

        // you must call the completion handler when you're done
        completionHandler()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 3
//        }
//        else {
//            return 2
//        }
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "isAlarmCell", for: indexPath)
                return cell
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "repeatCell", for: indexPath)
                return cell
            }
            else if indexPath.row == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "isDoNotDisturbCell", for: indexPath)
                return cell
            }
////        }
//        else {
            else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "fromTimePickerCell", for: indexPath)
                return cell
            }
            // indexPath.row == 4
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "toTimePickerCell", for: indexPath)
                return cell
            }

//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "isAlarmCell", for: indexPath)
//            return cell
//        }
//        else if indexPath.row == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "repeatCell", for: indexPath)
//            return cell
//        }
//        else if indexPath.row == 2 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "isDoNotDisturbCell", for: indexPath)
//            return cell
//        }
//        else if indexPath.row == 3 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "fromTimePickerCell", for: indexPath)
//            return cell
//        }
//        // indexPath.row == 4
//        else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "toTimePickerCell", for: indexPath)
//            return cell
//        }
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
        scheduleNotification()
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
