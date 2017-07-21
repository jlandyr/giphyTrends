//
//  APIController.swift
//  giphy
//
//  Created by Juan S. Landy on 21/7/17.
//  Copyright © 2017 eureka apps. All rights reserved.
//

import Foundation

class APIController {
    let API_KEY = "446b44f53f7a49a18827b38f2f10db68"
    //TODO:
    //implement the public API_KEY
    
    let limit = 20
    var urlComponents = NSURLComponents()

    init() {
        urlComponents.scheme = "http"
        urlComponents.host = "api.giphy.com"
        urlComponents.path = "/v1/gifs/trending"
        let queryItemToken = URLQueryItem(name: "api_key", value: API_KEY)
        let queryItemQuery = URLQueryItem(name: "limit", value: String(limit))
        urlComponents.queryItems = [queryItemToken, queryItemQuery]
    }
    
    func getUrl()-> URL{
        
        return urlComponents.url!
    }
}
