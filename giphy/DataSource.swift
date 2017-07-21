//
//  DataSource.swift
//  giphy
//
//  Created by Juan S. Landy on 21/7/17.
//  Copyright © 2017 eureka apps. All rights reserved.
//

import Foundation
import UIKit

class DataSource {

    func getData(object:AnyObject) -> URL?{
        
        if let dictionary = object as? [String: Any] {
            
            if let nestedDictionary = dictionary["images"] as? [String: Any] {
                if let originalDictionary = nestedDictionary["preview_gif"] as? [String: Any] {
                    if let urlGif = originalDictionary["url"] as? String {
                        return URL(string: urlGif)!
                    }
                }
            }
        }
        return nil
    }
}
