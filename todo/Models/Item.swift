//
//  Item.swift
//  todo
//
//  Created by Chris Del Rosario on 6/25/18.
//  Copyright © 2018 Chris Del Rosario. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var descriptionText: String = ""
    @objc dynamic var createdDate: Date?
    @objc dynamic var isCompleted: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

}


