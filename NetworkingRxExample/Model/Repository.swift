//
//  File.swift
//  NetworkingRxExample
//
//  Created by Alper Akinci on 21/11/2017.
//  Copyright © 2017 Alper Akinci. All rights reserved.
//

import Foundation
import Mapper

struct Repository: Mappable {

    let identifier: Int
    let language: String
    let name: String
    let fullName: String

    init(){
        self.identifier = 111
        self.language = "Swift"
        self.name = "Alper"
        self.fullName = "Alper Akinci"
    }

    init(map: Mapper) throws {
        try identifier = map.from("id")
        try language = map.from("language")
        try name = map.from("name")
        try fullName = map.from("full_name")
    }
}
