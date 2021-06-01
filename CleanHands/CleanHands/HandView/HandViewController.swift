//
//  HandViewController.swift
//  CleanHands
//
//  Created by hwangguk on 2021/05/07.
//

import UIKit

class HandViewController: UIViewController {

    var pathogenImageList = Array<UIImageView>()
    var capturedPathogenDic = [Pathogen:Int]()
    
    let pathogenCreateInterval:Double = 1
    let maxPathogenNum = 100
    let percentageOfGettingPathogen = 1.0
    
    @IBOutlet weak var handImageView: UIImageView!
    let pathogenImage = UIImage(named: "Pathogen")
    
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
            
            User.userState.handState.pathogenAmount = pathogenImageList.count
        }
    }
    
    @objc func onTimePassed() {
        let currentDate = Date()
        let expectedPathongenNumber = Int(currentDate.timeIntervalSince(User.userState.handState.lastWashTime)/pathogenCreateInterval)

        if (pathogenImageList.count < expectedPathongenNumber)  {
            createPathogen(numberOfCreate: expectedPathongenNumber - pathogenImageList.count)
        }
    }
    
    func removePathogen() {
        User.userState.handState.lastWashTime = Date()
        for i in pathogenImageList {
            getRandomPathogen()
            i.removeFromSuperview()
            //usleep(50000)
        }
        let newWashData = WashData(date: Date(), capturedPathogenDic: capturedPathogenDic)
        User.userState.washDataList.append(newWashData)
        print(newWashData)
        pathogenImageList = Array<UIImageView>()
    }
    

    func getRandomPathogen() {
        if (drand48() < percentageOfGettingPathogen) {
            let randomInt = Int.random(in: 0...dummyPathogenList.count-1)
            print(randomInt)
            let newPathogen = dummyPathogenList[randomInt]
            if (capturedPathogenDic[newPathogen] != nil) {
                capturedPathogenDic[newPathogen]! += 1
            }
            else {
                capturedPathogenDic[newPathogen] = 1
            }
        }
    }

    @IBAction func onWashButtonPressed(_ sender: Any) {
        presentTimerModal()
        removePathogen()
    }

//    @IBAction func test(_ sender: Any) {
//        createPathogen(numberOfCreate: 1)
//    }
    
    func presentTimerModal() {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "nextVC") else {return}
        self.present(nextVC, animated: true)
    }
}
