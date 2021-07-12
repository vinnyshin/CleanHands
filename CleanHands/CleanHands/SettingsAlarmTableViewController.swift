//
//  SettingsAlarmTableViewController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/06/09.
//

import UIKit
import UserNotifications

class SettingsAlarmTableViewController: UITableViewController {
    
    var delegate: TimeDelegate?
    var isAlarmOn: Bool = false
    var isDoNotDisturbOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isAlarmOn = User.userState.isAlarmOn
        isDoNotDisturbOn = User.userState.isDoNotDisturbOn
        
        delegate = TimeDelegate()
        delegate!.setRepeatTime = setRepeatTime
        
        self.tableView.tableFooterView = UIView()
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        setAlarmSwitch()
        setDoNotDisturb()
    }
    
    
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "손이 더러워요!"
        content.body = "손을 안씻은지 오래됐어요! 손을 씻어주세요."
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default
        
        let presetAlarms = ["30분", "1시간", "1시간 30분", "2시간", "2시간 30분", "3시간", "3시간 30분", "4시간"]
        
        var interval: Int = 0
        
        if let time = delegate?.time {
            if time == presetAlarms[0] {
                interval = 1800
            }
            else if time == presetAlarms[1] {
                interval = 1800 * 2
            }
            else if time == presetAlarms[2] {
                interval = 1800 * 3
            }
            else if time == presetAlarms[3] {
                interval = 1800 * 4
            }
            else if time == presetAlarms[4] {
                interval = 1800 * 5
            }
            else if time == presetAlarms[5] {
                interval = 1800 * 6
            }
            else if time == presetAlarms[6] {
                interval = 1800 * 7
            }
            else if time == presetAlarms[7] {
                interval = 1800 * 8
            }
            else {
                // default time is 2 hours
                interval = 1800 * 4
            }
        }
        
        let now = Date()
        
        var i = 0
        
        while true {
            let date: Date = now + TimeInterval(i)
            
            if isDoNotDisturbOn {
                
                let fromTime = User.userState.doNotDisturbFrom!
                let toTime = User.userState.doNotDisturbTo!
                
                if fromTime <= date && date <= toTime {
                    print(fromTime)
                    print(date)
                    print(toTime)
                    print()
                    i = i + interval
                    if i > 86400 {
                        break
                    }
                    continue
                }
            }
            
            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
            
            print(dateComponents)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
            
            i = i + interval
            if i >= 86400 {
                break
            }
        }
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
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "isAlarmCell", for: indexPath)
                return cell
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "repeatCell", for: indexPath)
                return cell
            }
            else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "isDoNotDisturbCell", for: indexPath)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "timePickerCell", for: indexPath)
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
        isAlarmOn = !isAlarmOn
        User.userState.isAlarmOn = !User.userState.isAlarmOn
        saveUserState()
        
        if isAlarmOn {
            scheduleNotification()
        } else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func doNotDisturbSwitchChanged(_ sender: UISwitch) {
        isDoNotDisturbOn = !isDoNotDisturbOn
        User.userState.isDoNotDisturbOn = !User.userState.isDoNotDisturbOn
        saveUserState()
        
        if isDoNotDisturbOn {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
        
        scheduleNotification()
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let alarmTimeSelectModalTableVC = segue.destination as? AlarmTimeSelectModalViewController {
            let delegate: TimeDelegate = self.delegate!
            alarmTimeSelectModalTableVC.delegate = delegate
        }
    }
    
    func setRepeatTime() {
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! RepeatCell
        if let timeString = delegate?.time {
            cell.repeatConfigLabel.text = timeString
        }
        
        scheduleNotification()
        
        self.tableView.deselectRow(at: IndexPath.init(row: 1, section: 0), animated: true)
    }
    
    func setAlarmSwitch() {
        let alarmCell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! IsAlarmCell
        let isDoNotDisturbCell = self.tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! IsDoNotDisturbCell
        
        alarmCell.alarmSwitch.isOn = isAlarmOn
        isDoNotDisturbCell.doNotDisturbSwitch.isOn = isDoNotDisturbOn
    }
    
    func setDoNotDisturb() {
        let timepickerCell = self.tableView.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! TimePickerCell
        
        if let fromTime = User.userState.doNotDisturbFrom,
           let toTime = User.userState.doNotDisturbTo {

            if toTime < Date() {
                timepickerCell.fromTimePicker.date = Date(timeInterval: 86400, since: fromTime)
                timepickerCell.toTimePicker.date = Date(timeInterval: 86400, since: toTime)
                User.userState.doNotDisturbFrom = timepickerCell.fromTimePicker.date
                User.userState.doNotDisturbTo = timepickerCell.toTimePicker.date
                saveUserState()
            } else {
                timepickerCell.fromTimePicker.date = fromTime
                timepickerCell.toTimePicker.date = toTime
            }
        } else {
            let from = Date()
            let to = Date()
            timepickerCell.fromTimePicker.date = from
            timepickerCell.toTimePicker.date = to
            User.userState.doNotDisturbFrom = from
            User.userState.doNotDisturbTo = to
            saveUserState()
        }
    }
    
    @IBAction func fromTimePickerChanged(_ sender: UIDatePicker) {
        User.userState.doNotDisturbFrom = sender.date
        saveUserState()
    }
    
    @IBAction func toTimePickerChanged(_ sender: UIDatePicker) {
        let timepickerCell = self.tableView.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! TimePickerCell
        
        if timepickerCell.fromTimePicker.date > sender.date {
            let date = sender.date + TimeInterval(86400)
            User.userState.doNotDisturbTo = date
        } else {
            User.userState.doNotDisturbTo = sender.date
        }
        saveUserState()
    }
}

class TimeDelegate {
    var time: String = ""
    var setRepeatTime: (() -> Void)?
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

class TimePickerCell: UITableViewCell {
    // 방해금지 시간 설정
    @IBOutlet weak var fromTimePicker: UIDatePicker!
    @IBOutlet weak var toTimePicker: UIDatePicker!
    
}
