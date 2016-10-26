# Swift Workshop
# Part 1: Create a new iOS project in Swift!

## Update

- Updated instructions for using Xcode 8.1  !!!  (Oct 30, 2016)

## Overview
- This workshop is aimed for beginners
- Step by step, follow along style guide
- Introduces setting up dependencies using [Cocoapods](https://cocoapods.org/)
- Introduces behavior driven testing using [Quick](https://github.com/Quick/Quick) and [Nimble](https://github.com/Quick/Nimble) frameworks
- We will collectively commit a terrible sin and not [TDD](https://www.amazon.ca/Test-Driven-Development-Kent-Beck/dp/0321146530) in this session (TDD warrants a whole separate session, and skipping it will help make each steps bite-sized.)
- Xcode 8.1 will be used

---

## Chapter 1: Setup a new Xcode project  
#  

1) Create a sample project in Xcode  
&nbsp;&nbsp;&nbsp;&nbsp;a) From the welcome screen, select **Create a new Xcode project**  
&nbsp;&nbsp;&nbsp;&nbsp;b) Select **iOS, Single View Application**, then click **Next**  
&nbsp;&nbsp;&nbsp;&nbsp;c) Name it **SwiftSample**, select Language as **Swift**, and only check **Include Unit Tests**  
#  
2) Install **Cocoapods** via terminal command  
 `sudo gem install cocoapods`  
#  
3) Init cocoapods on the new sample project.  **cd** into your project directory, then run the below command.  This generates a **Podfile**  
 `pod init`  
#  
4) Open generated **Podfile**. Uncomment line  
 `platform :ios, '10.0'`  
#  
5) Add dependencies to the **Podfile**'s **SwiftSampleTest** target  

```
pod 'Quick'
pod 'Nimble'
```

#  
6) Your **Podfile** should look like the following

```
# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'SwiftSample' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # Pods for SwiftSample

  target 'SwiftSampleTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick'
    pod 'Nimble'
  end
end
```
#
7) Install these dependencies by running  
 `pod install`  
#  
8) Close Xcode and open 'SwiftSample.xcworkspace'  
#  
9) Create a **.gitignore** file and add contents from the below link  
 <https://raw.githubusercontent.com/github/gitignore/master/Swift.gitignore>  
#  
10) This is a good place to create a first commit  
#  

---

## Chapter 2: Write your first test using Quick and Nimble
#  
1) Open **Main.storyboard** and select **View** within **View Controller Scene**  
#  
2) Add a `UILabel` into the **View**, give it constraints to make it visible on the screen  
#  
3) Open **ViewController.swift** on the right side pane by holding down the <kbd>⌥ option</kbd> key  
#  
4) Create a `UIOutlet` by right mouse button dragging the label from the screen into the code file.  Name it **label**  
#  
5) On the left panel, right click on `SwiftSampleTests` folder, right click to bring up a menu, then select **New File**  
#  
6) Select **iOS, Swift File**, and click **Next**, name the file **ViewControllerSpec**  
#  
7) Inside newly created **ViewControllerSpec.swift**, add the following code

```
import Quick
import Nimble

@testable import SwiftSample

class ViewControllerSpec: QuickSpec {
  override func spec() {
    // test code goes here
  }
}
```

8) Inside **spec** function, create the test subject as follows:  
`var subject: ViewController!`  
#  
9) Below that line, create a **beforeEach** block, and add the following code  

```
beforeEach {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    subject = storyboard.instantiateInitialViewController() as! ViewController

    expect(subject.view).notTo(beNil())
}
```
#  
10) Below the **beforeEach** block, create a **describe** block

```
describe("label text") {
}
```
#  
11) Within the **describe** block, add an **it** block

```
it("should have a nice greeting") {
    expect(subject.label.text).to(equal("Hello World!"))
}
```
#   
12) Run the test via **Menu -> Product -> Test**, or by pressing <kbd>Cmd</kbd> + <kbd>u</kbd>
#  
