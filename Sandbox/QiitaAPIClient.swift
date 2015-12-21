//
//  QiitaAPIClient.swift
//  Sandbox
//
//  Created by Masaaki Hirano on 2015/12/15.
//  Copyright © 2015年 codelust. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class QiitaAPIClient {
    
    // MARK: - Properties
    
    let scheme = "http"
    let host: String = "qiita.com"
    
    private let manager = Manager.sharedInstance
    
    static let sharedInstance: QiitaAPIClient = QiitaAPIClient()
    
    
    // MARK: - Initializers
    
    private init() {}
    
    
    // MARK: - Instance methods
    
    func request(method: Alamofire.Method = .GET, path: String, params: [String : String] = [:]) -> Observable<AnyObject!> {
        let request = self.manager.request(method, self.buildPath(path), parameters: params).request
        
        if let request = request  {
            return self.manager.session.rx_JSON(request)
        } else {
            fatalError("Invalid request")
        }
    }
    
    // MARK: - Private methods
    
    private func buildPath(path: String) -> NSURL {
        let trimmedPath = path.hasPrefix("/") ? path.substringFromIndex(path.startIndex.successor()) : path
        return NSURL(scheme: self.scheme, host: self.host, path: "/" + trimmedPath)!
    }
    
}