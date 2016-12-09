//
//  ViewController.swift
//  SwiftSample
//
//  Copyright © 2016 Pivotal. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let IMAGE_URL_STR = "https://placekitten.com/500/1000"
    let CITIES_LIST = [ "Paris", "London", "Washington", "New York", "Ottawa", "Toronto" ]
    let ARTISTS = [ "BEATLES, THE",
                    "MADONNA",
                    "JOHN, ELTON",
                    "PRESLEY, ELVIS",
                    "CAREY, MARIAH",
                    "WONDER, STEVIE",
                    "JACKSON, JANET",
                    "JACKSON, MICHAEL",
                    "HOUSTON, WHITNEY",
                    "THE ROLLING STONES" ]

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        imageLoadingIndicator.hidesWhenStopped = true
        
        // Start here
        
        
    }
    
    func getArtists() -> Observable<Array<String>> {
        return Observable.just(ARTISTS)
    }
    
    func rearrangeName(name: String) -> Observable<String> {
        return Observable.just(name).map { name in
            guard let indexOfComma = name.characters.index(of: ",") else {
                return name
            }
            
            let firstNameIndex = name.index(indexOfComma, offsetBy: +2)
            let firstNameRange = Range(uncheckedBounds: (lower: firstNameIndex, upper: name.endIndex))
            let lastNameRange = Range(uncheckedBounds: (lower: name.startIndex, upper: indexOfComma))
            var rearrangedName = name[firstNameRange]
            rearrangedName += " \(name[lastNameRange])"
            return rearrangedName
        }
    }
}
