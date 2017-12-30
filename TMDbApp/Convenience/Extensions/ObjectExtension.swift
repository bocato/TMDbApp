//
//  ObjectExtension.swift
//  TMDbApp
//
//  Created by Eduardo Sanches Bocato on 29/12/17.
//  Copyright © 2017 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit
import RealmSwift

extension Object {

    public class StringObject: Object {
        @objc dynamic var value: String?
    }
    
    public class IntObject: Object {
        @objc dynamic var value: Int = 0
    }
    
}
