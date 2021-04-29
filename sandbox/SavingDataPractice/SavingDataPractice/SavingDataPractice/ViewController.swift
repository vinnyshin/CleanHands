//
//  ViewController.swift
//  SavingDataPractice
//
//  Created by 신호중 on 2021/04/29.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(NSHomeDirectory())
        
        let url = Bundle.main.url(forResource: "SavingDataPropertyList", withExtension: "plist")!
        
        let data = try! Data(contentsOf: url)
        
        let decoded = try! PropertyListDecoder().decode(Dictionary<String, String>.self, from: data)
        
        print(decoded)
        
    }


}

