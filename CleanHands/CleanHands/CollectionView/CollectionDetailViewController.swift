//
//  CollectionDetailViewController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/05/27.
//

import UIKit

class CollectionDetailViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsStackView: UIStackView!
    @IBOutlet weak var pathogenImageView: UIImageView!
    
    @IBOutlet weak var pathogenKoreanNameLabel: UILabel!
    @IBOutlet weak var pathogenScientificNameLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var exterminationCountLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        animateDetails()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setPathogenImageUI()
        setStackViewUI()
    }
    
    func setPathogenImageUI() {
        pathogenImageView.superview?.bringSubviewToFront(pathogenImageView)
        
        pathogenImageView.layer.masksToBounds = true
        
        pathogenImageView.layer.cornerRadius = pathogenImageView.bounds.width / 2
        
        pathogenImageView.layer.borderWidth = 5
        pathogenImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    func setStackViewUI() {
        detailsStackView.layoutMargins = UIEdgeInsets(top: 100, left: 0, bottom: 100, right: 0)
        detailsStackView.isLayoutMarginsRelativeArrangement = true
    }
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        animateDetails()
//    }
    
//    func animateDetails() {
//        self.stackViewTopConstraint.constant = 100
//        self.stackViewOutlet.setNeedsUpdateConstraints()
//        UIView.animate(withDuration: 1.0) {
//            self.view.layoutIfNeeded()
//        }
//    }
}
