//
//  ViewControllerSpec.swift
//  SwiftSample
//
//  Created by NinjaSupreme on 2016-10-30.
//  Copyright © 2016 Pivotal. All rights reserved.
//

import Quick
import Nimble

@testable import SwiftSample

class ViewControllerSpec: QuickSpec {
    override func spec() {
        var subject: ViewController!
        
        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            subject = storyboard.instantiateInitialViewController() as! ViewController
            
            expect(subject.view).notTo(beNil())
        }
        
        describe("label text") {
            it("should have a nice greeting") {
                expect(subject.label.text).to(equal("Hello World!"))
            }
        }
    }
}
