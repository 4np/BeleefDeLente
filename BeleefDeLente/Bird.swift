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

public class Bird: NSObject, Mappable, CustomDebugStringConvertible {
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
    
//    //MARK: Image
//    
//    public func imageWithCompletion(completed: (image: UIImage?, error: String?) -> () = { image, error in }) {
//        guard let imageURL = imageURL else {
//            return completed(image: nil, error: "no image url for '\(name ?? "unknown bird")'")
//        }
//        
//        Alamofire.request(.GET, imageURL)
//            .responseImage { response in
//                guard let image = response.result.value else {
//                    return completed(image: nil, error: "error fetching image from \(imageURL)")
//                }
//                
//                completed(image: image, error: nil)
//            }
//    }
//    
//    public func scaledImageWithCompletion(ofSize size: CGSize, completed: (image: UIImage?, error: String?) -> () = { image, error in }) {
//        imageWithCompletion() { image, error in
//            guard let image = image else {
//                completed(image: nil, error: error)
//                return
//            }
//            
//            // scale image
//            let imageFilter = AspectScaledToFillSizeFilter(size: size)
//            completed(image: imageFilter.filter(image), error: nil)
//        }
//    }
}