//
//  Category.swift
//  Todoey
//
//  Created by Tony Qin on 7/9/18.
//  Copyright © 2018 SpaceX. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var categoryName : String = ""
    //forward relationship
    let items = List<Item>()
    
}
