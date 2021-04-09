//
//  DetailViewController.swift
//  practice1
//
//  Created by ihavebrave on 2021/04/09.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var myfield: UITextField!
    var selectedUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myfield.text = selectedUser.name
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
