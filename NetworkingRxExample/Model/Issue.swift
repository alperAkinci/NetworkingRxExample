//
//  Issue.swift
//  NetworkingRxExample
//
//  Created by Alper Akinci on 21/11/2017.
//  Copyright © 2017 Alper Akinci. All rights reserved.
//

import Foundation
import Mapper

struct Issue: Mappable {

    let identifier: Int
    let number: Int
    let title: String
    let body: String

    init(map: Mapper) throws {
        try identifier = map.from("id")
        try number = map.from("number")
        try title = map.from("title")
        try body = map.from("body")
    }
}
