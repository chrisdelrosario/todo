//
//  Category.swift
//  todo
//
//  Created by Chris Del Rosario on 6/25/18.
//  Copyright © 2018 Chris Del Rosario. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var descriptionText: String = ""
    let items = List<Item>()
}
