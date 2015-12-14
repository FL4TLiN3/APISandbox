//
//  QiitaRequestType.swift
//  Sandbox
//
//  Created by Masaaki Hirano on 2015/12/14.
//  Copyright © 2015年 codelust. All rights reserved.
//

import Foundation

public protocol QiitaRequestType: RequestType {
    var apiKey: String? { get set }
}

public extension QiitaRequestType where Self.Response: Mappable {
    public var method: HTTPMethod {
        return .GET
    }
    
    public var baseURL: NSURL {
        return NSURL(string: "https://wakatime.com/api/v1/")!
    }
    
    public func configureURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        guard let apiKey = self.apiKey else {
            throw WakaTimeAPIClientError.APIKeyNotDefined
        }
        guard let data = apiKey.dataUsingEncoding(NSUTF8StringEncoding) else {
            throw WakaTimeAPIClientError.AuthenticationFailure
        }
        let encryptedKey = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        URLRequest.setValue("Basic \(encryptedKey)", forHTTPHeaderField: "Authorization")
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