//
//  AlarmTimeSelectModalTableViewController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/06/09.
//

import UIKit

class AlarmTimeSelectModalTableViewController: UITableViewController {

    let presetAlarms = ["30분", "1시간", "1시간 30분", "2시간", "2시간 30분", "3시간", "3시간 30분", "4시간", "사용자 설정"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return presetAlarms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeSelectCell", for: indexPath)
        
        cell.textLabel?.text = presetAlarms[indexPath.row]

        return cell
    }
    
    @IBAction func navigationLeftButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

