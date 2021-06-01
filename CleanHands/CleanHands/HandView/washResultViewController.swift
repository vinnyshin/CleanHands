//
//  washResultViewController.swift
//  CleanHands
//
//  Created by hwangguk on 2021/06/01.
//

import UIKit

class washResultViewController: UIViewController {
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var forMoreDetailButton: UIButton!
    let washDataList = User.userState.washDataList
    //private var customTransitioningDelegate = TransitioningDelegate2()
    let padding:CGFloat = 30
    
    @IBOutlet weak var washResultCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.washResultCollectionView.delegate = self
        self.washResultCollectionView.dataSource = self
        
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
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func animateModal() {
        //view.layer.cornerRadius = 25
        modalPresentationStyle = .custom
        modalTransitionStyle = .coverVertical             // use whatever transition you want
        //transitioningDelegate = customTransitioningDelegate
    }
    
}
extension washResultViewController:UICollectionViewDelegate, UICollectionViewDataSource {
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
extension washResultViewController:UICollectionViewDelegateFlowLayout {
    
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
        return UIEdgeInsets(top: 0, left: padding, bottom: padding, right: padding)
    }
}

class PathogenCell : UICollectionViewCell {
    
    
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

class TransitioningDelegate2: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController2(presentedViewController: presented, presenting: presenting)
    }
}

class PresentationController2: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = presentingViewController.view.bounds
        let size = CGSize(width: bounds.width * 0.9, height: bounds.height*2.5)
        let origin = CGPoint(x: bounds.midX - size.width / 2, y: bounds.height)
        return CGRect(origin: origin, size: size)
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        presentedView?.autoresizingMask = [
            .flexibleTopMargin,
            .flexibleBottomMargin,
            .flexibleLeftMargin,
            .flexibleRightMargin
        ]

        presentedView?.translatesAutoresizingMaskIntoConstraints = true
    }
}
