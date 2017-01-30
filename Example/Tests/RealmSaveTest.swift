//
//  RealmSaveTest.swift
//  ACKReactiveExtensions
//
//  Created by Tomas Kohout on 11/01/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import class RealmSwift.Realm
import class RealmSwift.Object
import class RealmSwift.List
import class RealmSwift.Results
import ReactiveSwift
import Nimble
import ACKReactiveExtensions

class RealmSaveTest: XCTestCase {
    var realm: Realm!
    
    override var name: String? { return "RealmSaveTest" }
    
    
    override func setUp() {
        super.setUp()
        realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: self.name))
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func xtestThatObjectIsSaved() {
        let user = User(id: 102, name: "user_102")
        var saved = false
        user.reactive.save().startWithResult({ (res) in
            if case .success(_) = res {
                saved = true
            }
        })
        
        
        expect(saved).toEventually(beTrue())
        expect(self.realm.objects(User.self).filter("name = %@", "user_102").first).toEventuallyNot(beNil())
    }
}
