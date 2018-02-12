//
//  ViewController.swift
//  WaterCalc
//
//  Created by 水垣岳志 on 2018/02/11.
//  Copyright © 2018年 mzgkworks.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var groupView_1: InputView!
    @IBOutlet weak var groupView_2: InputView!
    @IBOutlet weak var groupView_3: InputView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        groupView_1.amountField.text = "3"
        groupView_2.amountField.text = "3"
        groupView_3.amountField.text = "3"
    }

}

