//
//  Item.swift
//  Todoey
//
//  Created by Tony Qin on 7/9/18.
//  Copyright © 2018 SpaceX. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var dateCreated : Date?
    @objc dynamic var done : Bool = false
    //backwards relationship
    //property is the same as items in categories
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
