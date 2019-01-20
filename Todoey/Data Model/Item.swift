//
//  Item.swift
//  Todoey
//
//  Created by John Cornelussen on 20/01/2019.
//  Copyright © 2019 John Cornelussen. All rights reserved.
//

import Foundation

// Codable = Encodable + Decodable

class Item: Codable {
  var title: String = ""
  var done: Bool = false
}
