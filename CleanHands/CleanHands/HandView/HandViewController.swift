//
//  HandViewController.swift
//  CleanHands
//
//  Created by hwangguk on 2021/05/07.
//


//TODO 타이머 관리
import UIKit
import GameplayKit

class HandViewController: UIViewController {
    let widthGererater = GKGaussianDistribution(randomSource: GKRandomSource(), lowestValue: -2, highestValue: 8)
    let handMatrix = [[2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5],
                      [2.7 ,2.7, 2.9, 2.9, 3.1, 3.1, 3.3],
                      [0.5, 1, 2, 3, 4, 5, 5.5],
                      [1, 1, 2, 3, 4, 5, 5.5],
                      [0.5, 1, 2, 3, 4, 5, 5.5],
                      [0.7, 1, 2, 2.5, 1, 2, 2.5],
                      [1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5]]
    
    var pathogenImageList = Array<UIImageView>()
    var capturedPathogenDic = [Pathogen:Int]()
    
    let pathogenCreateInterval:Double = 1
    let maxPathogenNum = 100
    let percentageOfGettingPathogen = 1.0
    
    var timerModalView : TimerModalViewController?
    var captureSuccess = false {
        didSet {
            if (captureSuccess) {
                timerModalView!.dismiss(animated: false, completion: nil)
                presentWashResultView()
                captureSuccess = false
            }
        }
    }
    
    @IBOutlet weak var handImageView: UIImageView!
    
    @IBOutlet weak var explainText: UILabel!
    
    let pathogenImage = UIImage(named: "Pathogen")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        updateUI()
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
        //let imageWidth = handImageView.frame.size.width
        let devidedImageWidth = Int(handImageView.frame.size.width/7)
        
        for _ in Range(1...number) {
            if (pathogenImageList.count >= maxPathogenNum) {
                break
            }
            let pathogenView = UIImageView(image: pathogenImage)
            
            var randomWidthIndex = widthGererater.nextInt()
            if (randomWidthIndex < 0) {
                randomWidthIndex = 0
            }
            if (randomWidthIndex > 6) {
                randomWidthIndex = 6
            }
            let widthRange = Range(devidedImageWidth * randomWidthIndex...devidedImageWidth * (randomWidthIndex + 1))
            let randomWidth = Int.random(in: widthRange)
            let heightRange = getRandomPositionRange(widthIndex: randomWidthIndex)
            
            let x = UInt32(randomWidth) + UInt32(imageLeftX)
            let y = Int.random(in: heightRange) + Int(imageUpY)
            
            pathogenView.frame = CGRect(x: Int(x), y: y, width: 10, height: 10)
            
            self.view.addSubview(pathogenView)
            pathogenImageList.append(pathogenView)
            
            User.userState.handState.pathogenAmount = pathogenImageList.count
        }
    }
    
    //손 모양에 맞춰 세균을 생성하기 위한 함수
    func getRandomPositionRange(widthIndex:Int) -> Range<Int>{
        let devidedImageHeight = handImageView.frame.size.height/7
        let yIndexinMatrix = Int.random(in: 0...6)
        let matrixValue = CGFloat(handMatrix[widthIndex][yIndexinMatrix])
        let startRange = Int(devidedImageHeight*matrixValue)
        let endRange = Int(devidedImageHeight*(matrixValue+1.0))

        return Range(startRange...endRange)
    }
    
    @objc func onTimePassed() {
        let currentDate = Date()
        let expectedPathongenNumber = Int(currentDate.timeIntervalSince(User.userState.handState.lastWashTime)/pathogenCreateInterval)

        if (pathogenImageList.count < expectedPathongenNumber)  {
//            createPathogen(numberOfCreate: expectedPathongenNumber - pathogenImageList.count)
            createPathogen(numberOfCreate: 100)
        }
        updateUI()
    }
    
    func updateUI() {
        let timeInterval = Date().timeIntervalSince(User.userState.handState.lastWashTime)
        let hour = Int(timeInterval/3600)
        let min = Int(timeInterval/60)
        if (hour > 23) {
            explainText.text = "마지막으로 손을 씻은 지 오랜 시간이 지났습니다.\n\(pathogenImageList.count) 마리의 세균을 서둘러 씻어내세요!"
            let attributedStr = NSMutableAttributedString(string: explainText.text!)
            attributedStr.addAttribute(.foregroundColor, value: UIColor(red: 178/255, green: 211/255, blue: 227/255, alpha: 1), range: (explainText.text! as NSString).range(of: "\(pathogenImageList.count) 마리"))
            explainText.attributedText = attributedStr
        }
        else if (timeInterval > 600) {
            explainText.text = "마지막으로 손을 씻은 지 \(hour)시간 \(min)분 지났습니다. \n\(pathogenImageList.count) 마리의 세균을 서둘러 씻어내세요!"
            let attributedStr = NSMutableAttributedString(string: explainText.text!)
            attributedStr.addAttribute(.foregroundColor, value: UIColor(red: 178/255, green: 211/255, blue: 227/255, alpha: 1), range: (explainText.text! as NSString).range(of: "\(hour)시간 \(min)분"))
            attributedStr.addAttribute(.foregroundColor, value: UIColor(red: 178/255, green: 211/255, blue: 227/255, alpha: 1), range: (explainText.text! as NSString).range(of: "\(pathogenImageList.count) 마리"))
            explainText.attributedText = attributedStr
        }
        else {
            explainText.text = "손이 깨끗해요!"
        }
    }
    
    func removePathogen() {
        User.userState.handState.lastWashTime = Date()
        capturedPathogenDic = [Pathogen:Int]()
        for i in pathogenImageList {
            getRandomPathogen()
            i.removeFromSuperview()
            //usleep(50000)
        }
        let newWashData = WashData(date: Date(), capturedPathogenDic: capturedPathogenDic)
        User.userState.washDataList.append(newWashData)
        
        for (capturedPathogen, number) in capturedPathogenDic {
            if (User.userState.pathogenDic[capturedPathogen] != nil) {
                User.userState.pathogenDic[capturedPathogen]! += number
            }
            else {
                User.userState.pathogenDic[capturedPathogen] = number
            }
        }
        
        pathogenImageList = Array<UIImageView>()
    }
    

    func getRandomPathogen() {
        if (drand48() < percentageOfGettingPathogen) {
            let randomInt = Int.random(in: 0...dummyPathogenList.count-1)
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
    
    func presentTimerModal() {
        guard let getTimerModalView = self.storyboard?.instantiateViewController(identifier: "timerModalView") else {return}
        let timerModalView = getTimerModalView as! TimerModalViewController
        timerModalView.handViewController = self
        self.timerModalView = timerModalView
        self.present(timerModalView, animated: true)
    }
    
    func presentWashResultView() {
        guard let resultView = self.storyboard?.instantiateViewController(identifier: "resultView") else {return}
        resultView.modalTransitionStyle = .coverVertical
        self.present(resultView, animated: true)
    }
}
