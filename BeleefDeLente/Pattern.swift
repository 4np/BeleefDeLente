//
//  Pattern.swift
//  BeleefDeLente
//
//  Created by Jeroen Wesbeek on 3/16/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireImage

public class Pattern: NSObject, Mappable, CustomDebugStringConvertible {
    public private(set) var name: String?
    public private(set) var pattern: String?
    
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
        name <- map["name"]
        pattern <- map["pattern"]
    }
}