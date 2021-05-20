//
//  HandViewController.swift
//  CleanHands
//
//  Created by hwangguk on 2021/05/07.
//

import UIKit

class HandViewController: UIViewController {

    var pathogenImageList = Array<UIImageView>()
    var currentDate : Date?
    var pathongenNumber : Double?
    
    @IBOutlet weak var handImageView: UIImageView!
    let pathogenImage = UIImage(named: "pathogen")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentDate = Date()
        pathongenNumber = currentDate!.timeIntervalSince(User.userState.handState.lastWashTime)
        
        print(pathongenNumber!)
    }
    
    func createPathogen(_ number:Int) {
        let imageLeftX = handImageView.frame.minX
        let imageUpY = handImageView.frame.minY
        let imageWidth = handImageView.frame.size.width
        let imageHeight = handImageView.frame.size.height
        
        for _ in Range(1...number) {
            let pathogenView = UIImageView(image: pathogenImage)
            
            let x = arc4random_uniform(UInt32(imageWidth)) + UInt32(imageLeftX)
            let y = arc4random_uniform(UInt32(imageHeight)) + UInt32(imageUpY)
            
            pathogenView.frame = CGRect(x: Int(x), y: Int(y), width: 10, height: 10)
            
            self.view.addSubview(pathogenView)
            pathogenImageList.append(pathogenView)
        }
    }
    
    func cleanPathogen() {
        for i in pathogenImageList {
            i.removeFromSuperview()
        }
        pathogenImageList = Array<UIImageView>()
    }

    @IBAction func onWashButtonPressed(_ sender: Any) {
        createPathogen(1)
    }

    @IBAction func test(_ sender: Any) {
        cleanPathogen()
    }
}
