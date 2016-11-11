//
//  ViewController.swift
//  SwiftSample
//
//  Copyright © 2016 Pivotal. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    let IMAGE_URL_STR = "https://static.pexels.com/photos/6506/alcohol-bar-drinks-party.jpg"
    let BEVERAGES_URL_STR = "https://lcboapi.com/products"
    let BEVERAGES_API_TOKEN = "MDphOWE3NjhjYS1hN2JlLTExZTYtODg4Yi02MzIzMjY0ZTU1M2I6Z0UydzVpNnkwTEFlWmhRTmF6T1luQlRCMVhMbjlzV1Mwd3px"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var beveragesTable: UITableView!
    @IBOutlet weak var beveragesLoadingIndicator: UIActivityIndicatorView!
    
    var beverages = [Beverage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        beveragesTable.delegate = self;
        beveragesTable.dataSource = self;
        
        imageLoadingIndicator.hidesWhenStopped = true
        beveragesLoadingIndicator.hidesWhenStopped = true
        
        // Start here
        
    }
    
    func parseJson(with data: Data) {
        
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beverages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let beverage = beverages[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ElementCell")
        
        cell.textLabel?.text = beverage.name
        cell.detailTextLabel?.text = beverage.category
        
        return cell
    }
}
