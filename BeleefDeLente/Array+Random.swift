//
//  Array+Random.swift
//  BeleefDeLente
//
//  Created by Jeroen Wesbeek on 3/17/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import Foundation

extension Array {
    extension Array {
        func sample() -> Element {
            let index = Int(arc4random_uniform(UInt32(self.count)))
            return self[index]
        }
    }
}