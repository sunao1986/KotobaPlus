//
//  Files.swift
//  KotobaPlus
//
//  Created by sunao on 2019/12/18.
//  Copyright © 2019 sunao. All rights reserved.
//

import UIKit
import RealmSwift

// File model 全ての親
class Files: Object {
    @objc dynamic var id : String = NSUUID().uuidString
    @objc dynamic var createAt = Date()
    @objc dynamic var filename: String = ""
    let labels = List<Label>()

    // IDをプライマリキーにする
    override static func primaryKey() -> String? {
        return "id"
    }
}

// Label model
class Label: Object {
    @objc dynamic var id : String = NSUUID().uuidString
    @objc dynamic var parentid : String = ""
    @objc dynamic var labelname = ""
    @objc dynamic var selectword = ""
    @objc dynamic var Labalowner: Files?
    let files = LinkingObjects(fromType: Files.self, property: "labels")
    let words = List<Word>()
    
    // IDをプライマリキーにする
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

// Word model
class Word: Object {
    @objc dynamic var id : String = NSUUID().uuidString
    @objc dynamic var parentid : String = ""
    @objc dynamic var grandparentid : String = ""
    @objc dynamic var word = ""
    @objc dynamic var wordowner: Label?
    let labels = LinkingObjects(fromType: Label.self, property: "words")
    
    // IDをプライマリキーにする
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
