//
//  APIManager.swift
//  BeleefDeLente
//
//  Created by Jeroen Wesbeek on 3/16/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import CleanroomLogger

public class APIManager: NSObject {
    public static let sharedInstance = APIManager()
    
    // Beleef De Lente Screensaver JSON
    private let sourceURL = "https://gist.githubusercontent.com/4np/837535fdb7f577bb0c03/raw/"
    
    //MARK: Meta data
    
    private func getMetaData(withCompletion completed: (metaData: MetaData?, error: String?) -> () = { metaData, error in }) {
        Alamofire.request(.GET, sourceURL)
            .responseObject { (response: Response<MetaData, NSError>) in
                guard let metaData = response.result.value else {
                    completed(metaData: nil, error: "could not fetch meta data (\(response.result.error))")
                    return
                }
                
                completed(metaData: metaData, error: nil)
            }
    }
    
    //MARK: Birds
    
    public func getBirds(withCompletion completed: (birds: [Bird]?, error: String?) -> () = { birds, error in }) {
        getMetaData() { metaData, error in
            guard let birds = metaData?.birds else {
                completed(birds: nil, error: "could not fetch birds")
                return
            }
            
            completed(birds: birds, error: nil)
        }
    }

    //MARK: Stream URL
    
    internal func getStreamURL(withPageURL pageURL: NSURL, andPlaylistURL playlistURL: NSURL, withCompletion completed: (streamURL: NSURL?, error: String?) -> () = { streamURL, error in }) {
        getMetaData() { [weak self] metaData, error in
            guard let confirmation = metaData?.confirmation, patterns = confirmation.patterns else {
                return completed(streamURL: nil, error: error)
            }
        
            self?.getQueryString(withPageURL: pageURL, andPlaylistURL: playlistURL) { queryString, error in
                guard let queryString = queryString else {
                    return completed(streamURL: nil, error: error)
                }

                var queryItems = [NSURLQueryItem]()
                
                do {
                    // iterate over patterns
                    for pattern in patterns {
                        // make sure all is well
                        guard let name = pattern.name, patternValue = pattern.pattern else {
                            continue
                        }
                        
                        // match pattern
                        let regex = try NSRegularExpression(pattern: patternValue, options: NSRegularExpressionOptions.CaseInsensitive)
                        let matches = regex.matchesInString(queryString, options: [], range: NSRange(location: 0, length: queryString.characters.count))
                        
                        guard let match = matches.first, range = self?.rangeFromNSRange(match.rangeAtIndex(1), forString: queryString) else {
                            continue
                        }
                        
                        // create query item
                        let text = queryString.substringWithRange(range)
                        let queryItem = NSURLQueryItem(name: name, value: text)
                        queryItems.append(queryItem)
                    }
                    
                    // construct url
                    guard let components = NSURLComponents(URL: playlistURL, resolvingAgainstBaseURL: false) else {
                        return completed(streamURL: nil, error: "error constructing stream url")
                    }
                    
                    components.queryItems = queryItems
                    
                    completed(streamURL: components.URL, error: nil)
                } catch {
                    completed(streamURL: nil, error: "error matching query items")
                }
            }
        }
    }
    
    private func getQueryString(withPageURL pageURL: NSURL, andPlaylistURL playlistURL: NSURL, withCompletion completed: (queryString: String?, error: String?) -> () = { queryString, error in }) {
        Alamofire.request(.GET, pageURL)
            .responseString { [weak self] response in
                // make sure the request was successful
                guard response.result.isSuccess, let value = response.result.value else {
                    return completed(queryString: nil, error: "could not fetch html from \(pageURL) (\(response.result.error))")
                }
                
                do {
                    let pattern = "\(playlistURL.URLString)([^\"|}]+)"
                    let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
                    let matches = regex.matchesInString(value, options: [], range: NSRange(location: 0, length: value.characters.count))
                    
                    guard let match = matches.first, range = self?.rangeFromNSRange(match.rangeAtIndex(1), forString: value) else {
                        return completed(queryString: nil, error: "could not match \(pattern) in html")
                    }
                    
                    let foundURL = value.substringWithRange(range)
                    completed(queryString: foundURL, error: nil)
                } catch {
                    completed(queryString: nil, error: "regular expression error (1)")
                }
        }
    }
    
    internal func rangeFromNSRange(nsRange: NSRange, forString str: String) -> Range<String.Index>? {
        let fromUTF16 = str.utf16.startIndex.advancedBy(nsRange.location, limit: str.utf16.endIndex)
        let toUTF16 = fromUTF16.advancedBy(nsRange.length, limit: str.utf16.endIndex)
        
        if let from = String.Index(fromUTF16, within: str),
            let to = String.Index(toUTF16, within: str) {
                return from ..< to
        }
        
        return nil
    }
}