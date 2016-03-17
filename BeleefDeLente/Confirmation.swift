//
//  Confirmation.swift
//  BeleefDeLente
//
//  Created by Jeroen Wesbeek on 3/16/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireImage

public class Confirmation: NSObject, Mappable, CustomDebugStringConvertible {
    public private(set) var patterns: [Pattern]?
    
    // debug printable
    override public var debugDescription: String {
        get {
            let className = String(self.dynamicType)
            
            guard let json = Mapper().toJSONString(self, prettyPrint: true) else {
                return className
            }
            
            return "\(className): \(json)"
        }
    }
    
    required public init?(_ map: Map) {
    }
    
    public func mapping(map: Map) {
        patterns <- map["patterns"]
    }
}