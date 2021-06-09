//
//  AlarmTimeSelectModalTableViewController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/06/09.
//

import UIKit

class AlarmTimeSelectModalViewController: UIViewController {
    var delegate: TimeDelegate?
    
    let presetAlarms = ["30분", "1시간", "1시간 30분", "2시간", "2시간 30분", "3시간", "3시간 30분", "4시간"]
    
    @IBOutlet weak var alarmTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alarmTableView.tableFooterView = UIView()
        self.alarmTableView.dataSource = self
        self.alarmTableView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let delegate = delegate {
            print("dismissed")
            delegate.setRepeatTime!()
        }
    }
}
extension AlarmTimeSelectModalViewController:UITableViewDelegate, UITableViewDataSource {
    
    

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return presetAlarms.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeSelectCell", for: indexPath)
        
        cell.textLabel?.text = presetAlarms[indexPath.row]

        return cell
    }
    
    @IBAction func navigationLeftButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let delegate = delegate,
           let time = cell?.textLabel?.text {
            delegate.time = time
        }
        self.dismiss(animated: true)
    }
}
