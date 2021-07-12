//
//  washResultViewController.swift
//  CleanHands
//
//  Created by hwangguk on 2021/06/01.
//

import UIKit

class WashResultViewController: UIViewController {
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var titleText: UILabel!
    let washDataList = User.userState.washDataList
    let padding:CGFloat = 30
    var titleString = ""
    var handViewController:HandViewController?
    
    @IBOutlet weak var washResultCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.washResultCollectionView.delegate = self
        self.washResultCollectionView.dataSource = self
        titleText.text = titleString
    }
    override func viewDidLayoutSubviews() {
        self.view.layoutIfNeeded()
        super.viewDidLayoutSubviews()
        for indexPath in washResultCollectionView.indexPathsForVisibleItems {
            let pathogenCell:PathogenCell = washResultCollectionView.cellForItem(at: indexPath) as! PathogenCell
            pathogenCell.pathogenImage.layer.cornerRadius = pathogenCell.pathogenImage.layer.bounds.width/2
            pathogenCell.borderView.layer.cornerRadius = pathogenCell.borderView.layer.bounds.width/2
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resultView.layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        animateModal()
    }
    @IBAction func onForMoreDetailPressed(_ sender: Any) {
        handViewController!.updateUI()
        self.dismiss(animated: true, completion: nil)
    }
    
    func animateModal() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .coverVertical
    }
    
}
extension WashResultViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return washDataList[washDataList.count - 1].capturedPathogenDic.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pathogenImageCell", for: indexPath) as! PathogenCell
    
        let washDic = washDataList[washDataList.count - 1].capturedPathogenDic
        
        let index = washDic.index(washDic.startIndex, offsetBy: indexPath.row)
        cell.item = washDic.keys[index]
        cell.number = washDic.values[index]
    
        return cell
    }
}
extension WashResultViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 100) / 2 - padding
        return CGSize(width: width, height: width*1.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: padding*1.5, bottom: padding, right: padding*1.5)
    }
}

class PathogenCell : UICollectionViewCell {
    
    
    @IBOutlet weak var pathogenImage: UIImageView!
    @IBOutlet weak var pathogenName: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var numberOfPathogen: UILabel!
    
    var item : Pathogen? {
        didSet {
            borderView.layer.cornerRadius = self.borderView.frame.height/2
            borderView.layer.masksToBounds = true
            borderView.layer.borderColor = CGColor(red: 25/255, green: 63/255, blue: 110/255, alpha: 1)
            borderView.layer.borderWidth = 3
            
            pathogenImage.layer.cornerRadius = self.pathogenImage.frame.height/2
            pathogenImage.layer.borderWidth = 2
            pathogenImage.layer.borderColor = UIColor.white.cgColor
            pathogenImage.clipsToBounds = true
            
            guard let pathogen = item else {
                return
            }
            let imageString = pathogen.image
            pathogenImage.image = UIImage(named: imageString)
            pathogenName.text = pathogen.name

        }
    }
    var number : Int? {
        didSet {
            guard let number = number else {
                return
            }
            numberOfPathogen.text = String(number)
        }
    }
}
