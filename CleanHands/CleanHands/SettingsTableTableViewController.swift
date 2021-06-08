//
//  SettingsTableTableViewController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/06/08.
//

import UIKit

class SettingsTableTableViewController: UITableViewController {

    let cellNameList = ["애플워치 연동", "알림 설정", "도움말"]
    let cellImageList = ["applewatch", "alarm", "questionmark.circle"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.barStyle = .black
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellNameList.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
        
        cell.settingsImageView.image = UIImage(systemName: cellImageList[indexPath.row])
        cell.settingsImageView.tintColor = UIColor(red: 25/255, green: 63/255, blue: 110/255, alpha: 1)
        cell.settingsImageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: CGFloat(25.0))
        
        let attributedNameString = NSMutableAttributedString()
            .normal(cellNameList[indexPath.row], fontSize: 15)
        cell.nameLabel.attributedText = attributedNameString
        
        let textColor = UIColor(red: 25.0 / 255, green: 63.0 / 255, blue: 110.0 / 255, alpha: 1.0)
        cell.nameLabel.textColor = textColor
        
        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if let indexPath = self.tableView.indexPathForSelectedRow,
//           let detailVC = segue.destination as? CollectionDetailViewController {
//            let index = User.userState.pathogenDic.index(User.userState.pathogenDic.startIndex, offsetBy: indexPath.row)
//            detailVC.selectedPathogen = User.userState.pathogenDic.keys[index]
//        }
//    }
}

class SettingsCell: UITableViewCell {
    
    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
}

