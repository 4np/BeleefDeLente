//
//  Version.swift
//  BeleefDeLente
//
//  Created by Jeroen Wesbeek on 3/18/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireImage

public class Version: NSObject, Mappable {
    public private(set) var latest: String?
    
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
        latest <- map["latest"]
    }
}