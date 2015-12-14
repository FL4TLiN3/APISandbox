//
//  Articles.swift
//  Sandbox
//
//  Created by Masaaki Hirano on 2015/12/14.
//  Copyright © 2015年 codelust. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Article: Mappable {
    public var title: String!
    
    public init?(_ map: Map) {
    }
    
    public mutating func mapping(map: Map) {
        self.title <- map["title"]
    }
}