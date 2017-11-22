//
//  RealmTest.swift
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
import enum Result.NoError
public typealias NoError = Result.NoError
import ACKReactiveExtensions

class Category: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    convenience init(id: Int, name: String){
        self.init()
        self.id = id
        self.name = name
    }
    
}

class User: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    let categories = List<Category>()
    convenience init(id: Int, name: String){
        self.init()
        self.id = id
        self.name = name
    }
    
    
}

class Unicorn: Object {
    dynamic var id: NSString = "0"
    dynamic var name: String = ""
    override static func primaryKey() -> String? { return "id" }
    convenience init(id: NSString, name: String){
        self.init()
        self.id = id
        self.name = name
    }
}



class RealmTest: XCTestCase {
    var realm: Realm!
    
    
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        realm = try! Realm()
        
        try! realm.write {
            let users = (0..<100).map { id -> User in
                let categories = (0..<10).map { Category(id: $0, name: "user\(id)_category\($0)") }
                let user = User(id: id, name: "user\(id)")
                user.categories.append(objectsIn: categories)
                return user
             }
            realm.add(users)
        }
        
    }
    
    override func tearDown() {
        super.tearDown()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func testThatPropertyInitialValueIsSentOnlyOnce() {
        let users = self.realm.objects(User.self).filter("name == 'user50'").reactive.property

        var valuesCount = 0
        
        users.producer.startWithValues { (results) in
            valuesCount += 1
        }
       
        expect(valuesCount).toEventuallyNot(beGreaterThan(1))
        expect(valuesCount) == 1
    }
    
    func testThatValuesInitialValueIsSent() {
        let usersProducer = self.realm.objects(User.self).filter("name == 'user50'").reactive.values
        
        var user50: User?
        
        usersProducer.ignoreError().startWithValues { (users) in
            user50 = users.first
        }
        
        expect(user50).toEventuallyNot(beNil())
        expect(user50?.name) == "user50"
    }
    
    func testThatChangesUpdatesAreSent() {
        let userChanges = self.realm.objects(User.self).reactive.changes
        
        var change: Change<Results<User>>?
        
        //Listen to changes
        userChanges.ignoreError().startWithValues { (changes) in
            change = changes
        }
        
        try! self.realm.write {
            self.realm.add(User(id: 101, name: "user101"))
        }
        
        expect(change).toEventually(beUpdate(withCount:101))
    }
    
    func testThatValuesNotificationBlockEndsWhenDeallocated() {
        var users: MutableProperty<Results<User>?>? = MutableProperty(nil)
        
        var producerTerminated = false
        var usersInitialized = false
        
        users! <~ self.realm.objects(User.self).reactive.values.on(terminated: {
            producerTerminated = true
        }).ignoreError().map { $0 }
        
        users?.producer.skipNil().take(first: 1).observe(on: UIScheduler()).startWithValues({ [unowned self] (results) in
            usersInitialized = true
            //Dealloc signal producer
            users = nil
            
            try! self.realm.write {
                self.realm.add(User(id: 101, name: "user101"))
            }
        })

        expect(usersInitialized).toEventually(beTrue())
        expect(producerTerminated).toEventually(beTrue())
        
        //Ok, this test is not exactly useful as it always succeeeds. 
        //The only way I managed to test it was to add breakpoint to update case in changes producer. It should be never called
    }
    
    func testThatObjectIsSaved() {
        let user = User(id: 102, name: "user102")
        user.reactive.save(update: false).start()
        
        expect(self.realm.objects(User.self).filter("name == 'user102'").first).toNot(beNil())
    }
    
    func testThatObjectIsDeleted() {
        let user = self.realm.objects(User.self).filter("name == 'user51'").first
        user?.reactive.delete().start()
        
        expect(self.realm.objects(User.self).filter("name == 'user51'").first).to(beNil())
    }
    
    func testThatOrphanedObjectAreDeleted() {
        
        try! realm.write {
            let unicorns = (0..<100).map { id -> Unicorn in Unicorn(id: "\(id)" as NSString, name: "unicorn\(id)") }
            realm.add(unicorns)
        }
        
        let orphanedQuery = self.realm.objects(Unicorn.self)
        
        expect(orphanedQuery.count) == 100
        
        let unicorn = Unicorn(id: "1000", name: "unicorn1000")
        try! realm.write {
            realm.add([unicorn], deleteOrphanedQuery: orphanedQuery)
        }
        
        expect(orphanedQuery.count) == 1
    }
    
    func beUpdate(withCount count: Int) -> MatcherFunc<Change<Results<User>>> {
        return MatcherFunc { expression, message in
            message.postfixMessage = "be update with \(count)"
            
            if let actual = try expression.evaluate(), case .update(let updates, _, _, _) = actual {
                return updates.count == count
            }
            return false
        }
    }
    
    class ViewController: UIViewController, RealmTableViewReloading, UITableViewDataSource {
        typealias Element = User
        weak var tableView: UITableView!
        weak var mockTableView: MockTableView!
        
        class MockTableView: UITableView {
            var insertCallback: (([Int]) -> Void)?
            
            override func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
                super.insertRows(at: indexPaths, with: animation)
                insertCallback?(indexPaths.map { $0.row })
            }
        }
        
        let query: Results<User>
        
        init(query: Results<User>){
            self.query = query
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func loadView(){
            super.loadView()
            let tableView = MockTableView()
            tableView.dataSource = self
            view.addSubview(tableView)
            self.tableView = tableView
            self.mockTableView = tableView
            self.reactive.changes <~ query.reactive.changes.ignoreError()
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return query.count
        }
    }
    
    
    func testTableViewIsReloaded() {
        let controller = ViewController(query: self.realm.objects(User.self).sorted(byKeyPath: "id", ascending: true))
        
        let user = User(id: 101, name: "user101")
        
        _ = controller.view
        
        var reloadedIndices: [Int]?
        controller.mockTableView.insertCallback = { indices in
            reloadedIndices = indices
        }
        
        try! realm.write {
            realm.add(user)
        }
        
        expect(reloadedIndices?.first).toEventually(equal(100))
    }

    
    
}
