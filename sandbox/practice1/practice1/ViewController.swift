//
//  ViewController.swift
//  practice1
//
//  Created by ihavebrave on 2021/04/09.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btn1: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailViewController{
            detailVC.text = users[0].name
        }
    }
    
    

}

