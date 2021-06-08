//
//  CollectionTableViewController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/05/07.
//

import UIKit

class CollectionTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .black
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()

        for indexPath in self.tableView.indexPathsForVisibleRows! {
            let collectionCell: CollectionCell = self.tableView.cellForRow(at: indexPath) as! CollectionCell
            collectionCell.pathogenImage.layer.cornerRadius = collectionCell.pathogenImage.layer.bounds.width / 2
            collectionCell.borderView.layer.cornerRadius = collectionCell.borderView.layer.bounds.width / 2
            
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if User.userState.pathogenDic.count == 0 {
            self.tableView.setEmptyMessage("손을 씻어주세요!")
        } else {
            self.tableView.restore()
        }

        return User.userState.pathogenDic.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
        // Configure the cell...
        // dummyPathoganDic의 시작 index부터 indexpath.row만큼 떨어진 index를 가져온다.
        let index = User.userState.pathogenDic.index(User.userState.pathogenDic.startIndex, offsetBy: indexPath.row)
        cell.item = User.userState.pathogenDic.keys[index]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow,
           let detailVC = segue.destination as? CollectionDetailViewController {
            let index = User.userState.pathogenDic.index(User.userState.pathogenDic.startIndex, offsetBy: indexPath.row)
            detailVC.selectedPathogen = User.userState.pathogenDic.keys[index]
        }
    }
}

class CollectionCell : UITableViewCell {
    
    @IBOutlet weak var pathogenLabel: UILabel!
    @IBOutlet weak var exterminationCountLabel: UILabel!
    @IBOutlet weak var pathogenImage: UIImageView!
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var labelStackView: UIStackView!
    
    var item: Pathogen? {
        didSet {
            guard let pathogen = item else {
                return
            }
            
            borderView.layer.cornerRadius = self.borderView.frame.height/2
            borderView.layer.masksToBounds = true
            borderView.layer.borderColor = CGColor(red: 25/255, green: 63/255, blue: 110/255, alpha: 1)
            borderView.layer.borderWidth = 3
            
            pathogenImage.image = UIImage(named: pathogen.image)
            pathogenImage.layer.masksToBounds = true
            pathogenImage.layer.cornerRadius = pathogenImage.bounds.width / 2
            pathogenImage.layer.borderColor = UIColor.white.cgColor
            pathogenImage.layer.borderWidth = 2
            
            let textColor = UIColor(red: 25.0 / 255, green: 63.0 / 255, blue: 110.0 / 255, alpha: 1.0)
            
            let attributedPathogenNameString = NSMutableAttributedString()
                .normal(pathogen.name, fontSize: 15)
            
            pathogenLabel.attributedText = attributedPathogenNameString
            pathogenLabel.textColor = textColor

            
            if let exterminationCount = User.userState.pathogenDic[pathogen] {
                let attributedExterminationCountString = NSMutableAttributedString()
                    .normal("\(exterminationCount) 마리 박멸", fontSize: 13)
                exterminationCountLabel.attributedText = attributedExterminationCountString
                exterminationCountLabel.textColor = textColor
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 0))
        
        labelStackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        labelStackView.isLayoutMarginsRelativeArrangement = true
    }
}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
