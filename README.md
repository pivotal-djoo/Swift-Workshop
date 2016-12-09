# Swift Workshop
# Part 3: A Brief Intro to ReactiveX with RxSwift

## Overview
- This workshop is aimed for beginners
- Step by step, follow along style guide
- Uses [RxSwift](https://github.com/ReactiveX/RxSwift), official port from [ReactiveX](http://reactivex.io/)
- Uses Xcode 8.1 and Swift 3.0

---

## 1. Setting Up (Optional)  

This part is optional.  Please complete this if you are curious about how to setup your project with correct framework dependencies.  This workshop project uses Cocoapods for managing project dependencies.  

1) Create a new folder named **workshop-p3**  

2) Clone this repository by running the command:  

```
git clone git@github.com:xtreme-david-joo/Swift-Workshop.git
```

3) Enter the project directory "Swift-Workshop" by using *cd* command.  Then, run command:  

```
open SwiftSample.xcworkspace
```

4) In Xcode, find **Pods** within the project navigator, unfold it, then open **Podfile**.

5) In **Podfile**, add the following lines below line `# Pods for SwiftSample`  

```
  pod 'RxSwift',    '~> 3.0'
  pod 'RxCocoa',    '~> 3.0'
```

6) Run `pod install` in terminal.  

7) Once the command completes, you're ready to go.  

---

## 2. An Observable and a Subscriber  

An observable emits items.  A subscriber consumes items.

1) Declare an observable like below.  

```
let myObservable: Observable<String> = Observable.create { observer in
    observer.on(.next("Hello world!"))
    observer.on(.completed)
    
    return Disposables.create()
}
```

2) Subscribe to this observable.  

```
myObservable.subscribe(onNext: { n in
    print(n)
}, onError: { error in
    print(error)
}, onCompleted: {
    print("Completed!")
}).addDisposableTo(disposeBag)
```

3) Test out the code by running it.  The results should look like the below.  

```
Hello world!
Completed!
```

## 3. Simpler Versions

There are many simpler and different ways to create observables.  Operators such as **create**, **just** and **from** are called creation operators.

1) **just** operator produces exact same observable as one from above, emitting just one item.  

```
Observable.just("Hello world!").subscribe(onNext: { n in
    print(n)
}).addDisposableTo(disposeBag)
```

2) **from** operator creates an observable which emits items in a given array.  

```
Observable.from(CITIES_LIST).subscribe(onNext: { n in
    print(n)
}).addDisposableTo(disposeBag)
```

## 4. What is a DisposeBag?

DisposeBag is used by the library to keep track of Observer objects and help deal with ARC and memory management.  Without using the **DisposeBag** you may get a retain cycle or objects getting deallocated prematurely.  

1) Declare a **DisposeBag** instance somewhere in your class.  

```
let disposeBag = DisposeBag()
```

2) Create and return a **Disposable** instance in Observables.  

```
let myObservable: Observable<String> = Observable.create { observer in
    observer.on(.next("Hello world!"))
    observer.on(.completed)
    
    return Disposables.create()
}

```

3) When subscribing, add the **Disposable** to **DisposeBag**.  

```
myObservable.subscribe(onNext: { n in
    print(n)
}, onError: { error in
    print(error)
}, onCompleted: {
    print("Completed!")
}).addDisposableTo(disposeBag)
```

More information on DisposeBag can be found here: [RayWenderlich](https://www.raywenderlich.com/138547/getting-started-with-rxswift-and-rxcocoa), [Rx-Marin](http://rx-marin.com/post/rxswift-timer-sequence-manual-dispose-bag/).

## 5. Transformation Operators

1) **map** operator can change a received data and emit it again.  

```
Observable.from(CITIES_LIST)
    .map { city -> String in
        return "Welcome to \(city)"
    }.subscribe(onNext: { n in
        print(n)
    }).addDisposableTo(disposeBag)
```



2) **filter** operator only emits items that satisfy a given condition.  

```
Observable.from(CITIES_LIST)
    .filter { city in
        return city.characters.count > 6
    }.map { city in
        return "Welcome to \(city)"
    }.subscribe(onNext: { n in
        print(n)
    }).addDisposableTo(disposeBag)
```

3) **toArray** operator collects all individual items emitted, then emits one list.  

```
Observable.from(CITIES_LIST)
    .filter { city in
        return city.characters.count > 6
    }.map { city in
        return "Welcome to \(city)"
    }.toArray()
    .subscribe(onNext: { n in
        print(n)
    }).addDisposableTo(disposeBag)
```

4) **flatMap** operator allows for nesting observables.  

```
self.getArtists()
    .flatMap { artists in
        return Observable.from(artists)
    }.flatMap { artist in
        return self.rearrangeName(name: artist)
    }.subscribe(onNext: { n in
        print(n)
    })
```

Learn more operators [here](http://reactivex.io/documentation/operators.html)  


## 6. Schedulers

You can use schedulers to ask which thread observer and subscriber would each run on.  By default, everything on an observable's pipeline runs on the same thread as the subscriber's.  Utility operators .observeOn and .subscribeOn can customize which schedulers each of them will run on.
 
**subscribeOn** tells which scheduler to start processing on.  Placement of this method has no effect.  
**observeOn** causes all operations below it to be executed on the specified scheduler.  
 
The below code snippet fetches an image in a background thread, then sets it to UI in main thread.  
 
```
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
```


#### Next session will cover error handling and testing.






