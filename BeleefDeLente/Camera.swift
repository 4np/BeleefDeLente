//
//  Camera.swift
//  BeleefDeLente
//
//  Created by Jeroen Wesbeek on 3/16/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireImage
import CleanroomLogger

public class Camera: NSObject, Mappable {
    public private(set) var title: String?
    private var imageURL: NSURL?
    private var pageURL: NSURL?
    private var playlistURL: NSURL?
    
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
        title <- map["title"]
        imageURL <- (map["image"], URLTransform())
        pageURL <- (map["page"], URLTransform())
        playlistURL <- (map["playlist"], URLTransform())
    }
    
    //MARK: Video stream
    
    public func getStreamURL(withCompletion completed: (url: NSURL?, error: String?) -> () = { url, error in }) {
        // make sure we have the page and playlist urls
        guard let pageURL = pageURL, playlistURL = playlistURL else {
            completed(url: nil, error: "required urls missing")
            return
        }
        
        APIManager.sharedInstance.getStreamURL(withPageURL: pageURL, andPlaylistURL: playlistURL) { streamURL, error in
            completed(url: streamURL, error: error)
        }
    }
}