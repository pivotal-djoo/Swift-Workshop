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
        
        // 2. 3. An observable and a subscriber
        
        let myObservable: Observable<String> = Observable.create { observer in
            observer.on(.next("Hello world!"))
            observer.on(.completed)
            
            return Disposables.create()
        }
        
        myObservable.subscribe(onNext: { n in
            print(n)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("Completed!")
        }).addDisposableTo(disposeBag)
      
        
        // 3. Simpler Versions
        // 3.1 .just
        
        Observable.just("Hello world!").subscribe(onNext: { n in
            print(n)
        }).addDisposableTo(disposeBag)
        
        // 3.2 .from
        
        Observable.from(CITIES_LIST).subscribe(onNext: { n in
            print(n)
        }).addDisposableTo(disposeBag)
        
        // 5 Operators
        // 5.1 .map
        
        Observable.from(CITIES_LIST)
            .map { city -> String in
                return "Welcome to \(city)"
            }.subscribe(onNext: { n in
                print(n)
            }).addDisposableTo(disposeBag)
        
        // 5.2 .filter
        
        Observable.from(CITIES_LIST)
            .filter { city in
                return city.characters.count > 6
            }.map { city in
                return "Welcome to \(city)"
            }.subscribe(onNext: { n in
                print(n)
            }).addDisposableTo(disposeBag)
        
        // 5.3 .toArray
        
        Observable.from(CITIES_LIST)
            .filter { city in
                return city.characters.count > 6
            }.map { city in
                return "Welcome to \(city)"
            }.toArray()
            .subscribe(onNext: { n in
                print(n)
            }).addDisposableTo(disposeBag)
        
        // 5.4 .flatMap
        
        self.getArtists()
            .flatMap { artists in
                return Observable.from(artists)
            }.flatMap { artist in
                return self.rearrangeName(name: artist)
            }.subscribe(onNext: { n in
                print(n)
            }).addDisposableTo(disposeBag)
        
        // 6. Schedulers
        
        imageLoadingIndicator.startAnimating()
        
        Observable.just(IMAGE_URL_STR)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { urlStr -> UIImage in
                let imageUrl = URL(string: urlStr)!
                let imageData = NSData(contentsOf: imageUrl)!
                return UIImage(data: imageData as Data)!
            }.observeOn(MainScheduler.instance)
            .subscribe(onNext: { image in
                self.imageLoadingIndicator.stopAnimating()
                self.imageView.image = image
            }).addDisposableTo(disposeBag)
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
