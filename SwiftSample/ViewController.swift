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
        
        // fetch image
        
        imageLoadingIndicator.startAnimating()
        
        let imageUrl = URL(string: IMAGE_URL_STR)!
        
        DispatchQueue.global().async {
            let imageData = NSData(contentsOf: imageUrl)!
            
            DispatchQueue.main.async {
                self.imageLoadingIndicator.stopAnimating()
                
                let image = UIImage(data: imageData as Data)
                self.imageView.image = image;
            }
        }

        // fetch beverages list data
        
        let beveragesUrl = URL(string: BEVERAGES_URL_STR)!
        
        var request = URLRequest(url: beveragesUrl)
        request.httpMethod = "GET"
        request.setValue("Token \(BEVERAGES_API_TOKEN)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in

            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                self.parseJson(with:data!)
            }

            self.beveragesLoadingIndicator.stopAnimating()
        }
        
        beveragesLoadingIndicator.startAnimating()
        task.resume()
    }
    
    func parseJson(with data: Data) {
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
            
            if let results = jsonDict?["result"] as? NSArray {
                for beverageData in results {
                    let beverageDictionary = beverageData as? NSDictionary
                    let name = beverageDictionary?["name"] as! String
                    let category = beverageDictionary?["primary_category"] as! String
                    let beverage = Beverage(name: name, category: category)
                    self.beverages.append(beverage)
                }
                
                self.beveragesTable.reloadData()
            }
        } catch {
            print("JSON parsing failed")
        }
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
