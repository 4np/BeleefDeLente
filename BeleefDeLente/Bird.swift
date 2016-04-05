//
//  Bird.swift
//  BeleefDeLente
//
//  Created by Jeroen Wesbeek on 3/16/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireImage

public class Bird: NSObject, Mappable {
    public private(set) var name: String?
    public private(set) var imageURL: NSURL?
    public private(set) var cameras: [Camera]?
    
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
        imageURL <- (map["image"], URLTransform())
        cameras <- map["cameras"]
    }
}