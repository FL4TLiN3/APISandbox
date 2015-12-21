//
//  QiitaRequestType.swift
//  Sandbox
//
//  Created by Masaaki Hirano on 2015/12/14.
//  Copyright © 2015年 codelust. All rights reserved.
//

import Foundation
import APIKit
import ObjectMapper

enum QiitaAPIClientError: ErrorType {
    case APIKeyNotDefined
    case AuthenticationFailure
}

public protocol QiitaRequestType: RequestType {
    var apiKey: String? { get set }
}

public extension QiitaRequestType where Self.Response: Mappable {
    
    public var method: HTTPMethod {
        return .GET
    }
    
    public var baseURL: NSURL {
        return NSURL(string: "http://qiita.com/api/v2/")!
    }
    
    public func configureURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        guard let apiKey = self.apiKey else {
            throw QiitaAPIClientError.APIKeyNotDefined
        }
        URLRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        return URLRequest
    }
    
    public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        guard let dictionary = object as? [String: AnyObject] else {
            return nil
        }
        
        guard let data = dictionary["data"] as? [String: AnyObject] else {
            return nil
        }
        
        let mapper = Mapper<Response>()
        guard let object = mapper.map(data) else {
            return nil
        }
        return object
    }
}

public struct ItemsRequest: QiitaRequestType {
    
    // Statを取得するAPI
    public typealias Response = Article
    public var apiKey: String? = "fb3778dbf21bd306f49e1c56c97ab4a1977b5e2c"
    public var path: String {
        return "/items/"
    }
}