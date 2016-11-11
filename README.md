# Swift Workshop
# Part 2: Basic Networking

## Overview
- This workshop is aimed for beginners
- Step by step, follow along style guide
- Uses [DispatchQueue](https://developer.apple.com/reference/dispatch/dispatchqueue), [NSData](https://developer.apple.com/reference/foundation/nsdata), and [URLSession](https://developer.apple.com/reference/foundation/urlsession)
- We will collectively commit a terrible sin and not [TDD](https://www.amazon.ca/Test-Driven-Development-Kent-Beck/dp/0321146530) in this session (TDD warrants a whole separate session, and skipping it will help make each steps bite-sized.)
- Xcode 8.1 is used in this workshop

---

## Chapter 1: DispatchQueue and NSData

DispatchQueue is a way to run async blocks  
In this chapter, we'll leverage async blocks to use a blocking method to load an image

1) Within provided **viewDidload()** method, insert the following to begin showing a loading spinner  
```
imageLoadingIndicator.startAnimating()
```

2) Declare a URL with IMAGE_URL_STR  
```
let imageUrl = URL(string: IMAGE_URL_STR)!
```

3) Create an async block  
```
DispatchQueue.global().async {
	// worker thread
}
```

4) Within the async block, fetch image data from URL  
```
let imageData = NSData(contentsOf: imageUrl)!
```

5) Create a main thread block below  
```
DispatchQueue.main.async {
  // main thread
}
```

6) Within the main thread block, convert retrieved data to UIImage and set to self.imageView  
```
let image = UIImage(data: imageData as Data)
self.imageView.image = image;
```

7) Hide the loading spinner  
```
imageLoadingIndicator.stopAnimating()
```

Your code should look like the following  
```
imageLoadingIndicator.startAnimating()

let imageUrl = URL(string: IMAGE_URL_STR)!

DispatchQueue.global().async {
    // worker thread
    let imageData = NSData(contentsOf: imageUrl)!

    DispatchQueue.main.async {
        // main thread
        let image = UIImage(data: imageData as Data)
        self.imageView.image = image;

        self.imageLoadingIndicator.stopAnimating()
    }
}
```

8) Run the app by pressing <kbd>Cmd</kbd> + <kbd>R</kbd>

---

## Chapter 2: URLSession

URLSession is Apple's update to NSURLConnection.  URLSession provides richer features compared to NSData such as handling worker threads, and allowing for more customized network calls.  
In this chapter, we'll make a network call to an endpoint that requires a header value and returns a JSON data.

1) Declare a **URL** within provided `viewDidLoad()` methods
```
let beveragesUrl = URL(string: BEVERAGES_URL_STR)!
```

2) Declare a **URLRequest** giving it the *beveragesUrl*
```
var request = URLRequest(url: beveragesUrl)
```

3) Set http method of the request
```
request.httpMethod = "GET"
```

4) Add **BEVERAGES_API_TOKEN** as a header value of the request
```
request.setValue("Token \(BEVERAGES_API_TOKEN)", forHTTPHeaderField: "Authorization")
```

5) Obtain a **URLSession**
```
let session = URLSession.shared
```

6) Add a task to the session providing it the request object built previously
```
let task = session.dataTask(with: request) {
	(data, response, error) -> Void in

	// main thread
}
```

7) Check response for a **200** status code
```
let httpResponse = response as! HTTPURLResponse
let statusCode = httpResponse.statusCode

if (statusCode == 200) {
	// parse the data here
}
```

8) Pass the retrieved data to the parse method provided
```
self.parseJson(with:data!)
```

9) Hide the loading spinner  
```
self.beveragesLoadingIndicator.stopAnimating()
```

10) Below where we declared **task**, insert the following to begin showing a loading spinner  
```
beveragesLoadingIndicator.startAnimating()
```

11) Kick off the task which will begin fetching data  
```
task.resume()
```

Your code should look like the following  
```
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
```

12) In the **parseJson** method, use **JSONSerialization** to read the JSON data  
```
do {
	let jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary

	// update table with new data
} catch {
    print("JSON parsing failed")
}
```

13) Look for array with key **"result"**  
```
if let results = jsonDict?["result"] as? NSArray {

}
```

14) Iterate through the results array  
```
for beverageData in results {
	// parse individual beverageData
}
```

15) Retrieve **name** and **category** of each beverage  
```
let beverageDictionary = beverageData as? NSDictionary
let name = beverageDictionary?["name"] as! String
let category = beverageDictionary?["primary_category"] as! String
```

16) Create a **Beverage** struct instance for each beverage and append to provided array  **self.beverages**
```
let beverage = Beverage(name: name, category: category)
self.beverages.append(beverage)
```

17) After iterating, reload table view  
```
self.beveragesTable.reloadData()
```

Your **parseJson()** method should look like the following  
```
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
```

18) Run the app by pressing <kbd>Cmd</kbd> + <kbd>R</kbd>
