//
//  Category.swift
//  Todoey
//
//  Created by John Cornelussen on 31/01/2019.
//  Copyright © 2019 John Cornelussen. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object {
  @objc dynamic var name: String = ""
  @objc dynamic var displayColor = UIColor.randomFlat.hexValue()
  let items = List<Item>()
}

