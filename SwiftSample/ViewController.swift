//
//  ViewController.swift
//  SwiftSample
//
//  Created by NinjaSupreme on 2016-10-25.
//  Copyright © 2016 Pivotal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Hello World!"
    }
}
