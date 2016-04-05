//
//  MetaData.swift
//  BeleefDeLente
//
//  Created by Jeroen Wesbeek on 3/16/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireImage

public class MetaData: NSObject, Mappable {
    public private(set) var version: Version?
    public private(set) var confirmation: Confirmation?
    public private(set) var birds: [Bird]?
    
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
        version <- map["version"]
        confirmation <- map["confirmation"]
        birds <- map["birds"]
    }
}