//
//  Pw_UserDefault.swift
//  CombineLoggin
//
//  Created by 游宗諭 on 2019/10/8.
//  Copyright © 2019 游宗諭. All rights reserved.
//

import Foundation

@propertyWrapper

struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
