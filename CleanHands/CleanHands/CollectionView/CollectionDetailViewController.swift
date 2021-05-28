//
//  CollectionDetailViewController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/05/27.
//

import UIKit

class CollectionDetailViewController: UIViewController {
    
    @IBOutlet weak var stackViewOutlet: UIView!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        animateDetails()
        // Do any additional setup after loading the view.
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
    
    func animateDetails() {
        self.stackViewTopConstraint.constant = 100
        self.stackViewOutlet.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
}
