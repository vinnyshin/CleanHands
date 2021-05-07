//
//  HandViewController.swift
//  CleanHands
//
//  Created by hwangguk on 2021/05/07.
//

import UIKit

class HandViewController: UIViewController {

    var pathogenImageList = Array<UIImageView>()
    
    @IBOutlet weak var handImageView: UIImageView!
    let pathogenImage = UIImage(named: "pathogen")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    func createPathogen(_ number:Int) {
        for _ in Range(1...number) {
            let pathogenView = UIImageView(image: pathogenImage)
            let x = arc4random_uniform(UInt32(handImageView.frame.maxX))
            let y = arc4random_uniform(UInt32(handImageView.frame.maxY))
            
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
