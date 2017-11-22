//
//  Extensions.swift
//  NetworkingRxExample
//
//  Created by Alper Akinci on 14/11/2017.
//  Copyright © 2017 Alper Akinci. All rights reserved.
//

import Foundation


extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}
