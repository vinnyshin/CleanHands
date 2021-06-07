//
//  CollectionDetailViewController.swift
//  CleanHands
//
//  Created by 신호중 on 2021/05/27.
//

import UIKit

class CollectionDetailViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var detailsStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsStackView: UIStackView!
    @IBOutlet weak var pathogenImageView: UIImageView!
    
    @IBOutlet weak var pathogenKoreanNameLabel: UILabel!
    @IBOutlet weak var pathogenScientificNameLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var exterminationCountLabel: UILabel!
    
    @IBOutlet weak var decriptionLabel: UILabel!
    @IBOutlet weak var symptomLabel: UILabel!
    @IBOutlet weak var careMethodLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var selectedPathogen: Pathogen!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(selectedPathogen)
        setPathogenImageUI()
        setDetailsStackViewUI()
        setHeaderUI()
        setContentsUI()
//        animateDetails()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setDetailsStackViewUI() {
        detailsStackView.layoutMargins = UIEdgeInsets(top: 100, left: 0, bottom: 100, right: 0)
        detailsStackView.isLayoutMarginsRelativeArrangement = true
    }

    func setPathogenImageUI() {
        pathogenImageView.image = UIImage(named: selectedPathogen.image)
        
        pathogenImageView.superview?.bringSubviewToFront(pathogenImageView)
        pathogenImageView.layer.masksToBounds = true
        
        pathogenImageView.layer.cornerRadius = pathogenImageView.bounds.width / 2
        
        pathogenImageView.layer.borderWidth = 5
        pathogenImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    func setHeaderUI() {
        pathogenKoreanNameLabel.text = selectedPathogen.name
        
        pathogenScientificNameLabel.text = "학명 추가 필요"
        
        let frequency = selectedPathogen.frequency.toString
        frequencyLabel.text = "출현 빈도 \(frequency)"
        
        if let exterminationCount = User.userState.pathogenDic[selectedPathogen] {
            exterminationCountLabel.text = "박멸 횟수 \(exterminationCount)"
        }
    }
    
    func setContentsUI() {
        decriptionLabel.text = selectedPathogen.description
        symptomLabel.text = selectedPathogen.symptom
        careMethodLabel.text = selectedPathogen.careMethod
        locationLabel.text = selectedPathogen.location
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
