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
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var exterminationCountLabel: UILabel!
    
    @IBOutlet weak var decriptionLabel: UILabel!
    @IBOutlet weak var symptomLabel: UILabel!
    @IBOutlet weak var careMethodLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet var headerLabelCollection: [UILabel]!
    
    @IBOutlet var detailInfoViewCollection: [UIView]!
    
    @IBOutlet var detailInfoStackViewCollection: [UIStackView]!
    
    @IBOutlet var detailInfoViewConstraintCollection: [NSLayoutConstraint]!
    
    
    var selectedPathogen: Pathogen!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPathogenImageUI()
        setDetailsStackViewUI()
        setPathogenHeader()
        setContentsUI()
        
        for headerLabel in headerLabelCollection {
            setHeaderLabelUI(headerLabel)
        }
        
        for detailInfoView in detailInfoViewCollection {
            setShadowUI(detailInfoView)
        }
        
        for detailInfoStackView in detailInfoStackViewCollection {
            setMarginUI(detailInfoStackView)
        }
        
        for detailInfoViewConstraint in detailInfoViewConstraintCollection {
            setDetailInfoViewConstraint(detailInfoViewConstraint)
        }
//        animateDetails()
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
    
    func setPathogenHeader() {
        let attributedNameString = NSMutableAttributedString()
            .bold(selectedPathogen.name, fontSize: 20)

        pathogenKoreanNameLabel.attributedText = attributedNameString
        
        
        let frequency = selectedPathogen.frequency.toString
        let attributedFrequencyString = NSMutableAttributedString()
            .normal("출몰 빈도 ", fontSize: 15)
            .bold("\(frequency)", fontSize: 15)
        
        frequencyLabel.attributedText = attributedFrequencyString
        
        if let exterminationCount = User.userState.pathogenDic[selectedPathogen] {
            let attributedExterminationCountString = NSMutableAttributedString()
                .normal("박멸 횟수 ", fontSize: 15)
                .bold("\(exterminationCount)", fontSize: 15)
            exterminationCountLabel.attributedText = attributedExterminationCountString
            
        }
    }
    
    func setHeaderLabelUI(_ headerLabel: UILabel) {
        headerLabel.textAlignment = .center
        let textColor = UIColor(red: 25.0 / 255, green: 63.0 / 255, blue: 110.0 / 255, alpha: 1.0)
        
        headerLabel.textColor = textColor
        
        
        
        let attributedHeaderString = NSMutableAttributedString()
            .bold(headerLabel.text!, fontSize: 15)
        
        headerLabel.attributedText = attributedHeaderString
        
//        headerLabel.font = headerLabel.font.withSize(15)
        
    }
    
    func setContentsUI() {
        decriptionLabel.text = selectedPathogen.description + selectedPathogen.description + selectedPathogen.description
        
        symptomLabel.text = selectedPathogen.symptom
        careMethodLabel.text = selectedPathogen.careMethod
        locationLabel.text = selectedPathogen.location
    }
    
    func setShadowUI(_ view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.01
//        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
        view.layer.masksToBounds = false
        
    }
    
    
    func setMarginUI(_ stackView: UIStackView) {
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    func setDetailInfoViewConstraint(_ constraint: NSLayoutConstraint) {
        constraint.constant = 25
    }
    
}

extension NSMutableAttributedString {
    func bold(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: fontSize)]
        self.append(NSMutableAttributedString(string: text, attributes: attrs))
        return self
    }
    
    func normal(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: fontSize)]
        self.append(NSMutableAttributedString(string: text, attributes: attrs))
        return self
    }
}
