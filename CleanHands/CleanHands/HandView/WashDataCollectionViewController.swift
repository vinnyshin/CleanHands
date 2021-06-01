//
//  WashDataCollectionViewController.swift
//  CleanHands
//
//  Created by hwangguk on 2021/05/27.
//

import UIKit

private let reuseIdentifier = "Cell"

class WashDataCollectionViewController: UICollectionViewController {

    let washDataList = User.userState.washDataList
    private var customTransitioningDelegate = TransitioningDelegate2()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        animateModal()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        //print(washDataList[washDataList.count - 1].capturedPathogenDic.count)
        return washDataList[washDataList.count - 1].capturedPathogenDic.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pathogenImageCell", for: indexPath) as! PathogenImageCell
    
        let washDic = washDataList[washDataList.count - 1].capturedPathogenDic
        
        let index = washDic.index(washDic.startIndex, offsetBy: indexPath.row)
        cell.item = washDic.keys[index]
        cell.number = washDic.values[index]
        // Configure the cell
    
        return cell
    }
    func animateModal() {
        //view.layer.cornerRadius = 25
        modalPresentationStyle = .custom
        modalTransitionStyle = .coverVertical             // use whatever transition you want
        transitioningDelegate = customTransitioningDelegate
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension WashDataCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200.0, height: 200.0)
    }
}

class PathogenImageCell : UICollectionViewCell {
    
    @IBOutlet weak var pathogenImage: UIImageView!
    @IBOutlet weak var pathogenName: UILabel!
    
    @IBOutlet weak var numberOfPathogen: UILabel!
    
    var item : Pathogen? {
        didSet {
            pathogenImage.layer.cornerRadius = pathogenImage.frame.height/2
            pathogenImage.layer.borderWidth = 1
            pathogenImage.layer.borderColor = UIColor.clear.cgColor
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
