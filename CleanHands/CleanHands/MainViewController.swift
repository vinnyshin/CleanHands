//
//  MainViewController.swift
//  CleanHands
//
//  Created by hwangguk on 2021/06/09.
//

import UIKit

class MainViewController: UITabBarController {
    @IBOutlet weak var tabBarItems: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidLayoutSubviews() {
        tabBarItems.items?[0].imageInsets = UIEdgeInsets(top: -3, left: 0, bottom: 3, right: 0)
        tabBarItems.items?[1].imageInsets = UIEdgeInsets(top: -3, left: 0, bottom: 3, right: 0)
        tabBarItems.items?[2].imageInsets = UIEdgeInsets(top: -3, left: 0, bottom: 3, right: 0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
