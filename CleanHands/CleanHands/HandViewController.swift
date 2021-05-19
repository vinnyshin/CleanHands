//
//  HandViewController.swift
//  CleanHands
//
//  Created by hwangguk on 2021/05/07.
//

import UIKit

class HandViewController: UIViewController {

    var pathogenImageList = Array<UIImageView>()
    var pathogenCreateInterval:Double = 10
    var maxPathogenNum = 100
    
    @IBOutlet weak var handImageView: UIImageView!
    let pathogenImage = UIImage(named: "pathogen")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onTimePassed()
    }
    
    func startTimer() {
        Timer.scheduledTimer(timeInterval: pathogenCreateInterval, target: self, selector: #selector(onTimePassed), userInfo: nil, repeats: true)
    }
    
    func createPathogen(numberOfCreate number:Int) {
        let imageLeftX = handImageView.frame.minX
        let imageUpY = handImageView.frame.minY
        let imageWidth = handImageView.frame.size.width
        let imageHeight = handImageView.frame.size.height
        
        for _ in Range(1...number) {
            if (pathogenImageList.count >= maxPathogenNum) {
                break
            }
            let pathogenView = UIImageView(image: pathogenImage)
            
            let x = arc4random_uniform(UInt32(imageWidth)) + UInt32(imageLeftX)
            let y = arc4random_uniform(UInt32(imageHeight)) + UInt32(imageUpY)
            
            pathogenView.frame = CGRect(x: Int(x), y: Int(y), width: 10, height: 10)
            
            self.view.addSubview(pathogenView)
            pathogenImageList.append(pathogenView)
            
            User.userState.handState.pathoganAmount = pathogenImageList.count
        }
    }
    
    @objc func onTimePassed() {
        let currentDate = Date()
        let expectedPathongenNumber = Int(currentDate.timeIntervalSince(User.userState.handState.lastWashTime)/pathogenCreateInterval)

        if (pathogenImageList.count < expectedPathongenNumber)  {
            createPathogen(numberOfCreate: expectedPathongenNumber - pathogenImageList.count)
        }
    }
    
    func cleanPathogen() {
        for i in pathogenImageList {
            i.removeFromSuperview()
            //usleep(50000)
        }
        pathogenImageList = Array<UIImageView>()
    }

    @IBAction func onWashButtonPressed(_ sender: Any) {
        createPathogen(numberOfCreate: 1)
    }

    @IBAction func test(_ sender: Any) {
        cleanPathogen()
    }
}
