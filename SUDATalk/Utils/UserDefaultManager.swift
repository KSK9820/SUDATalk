//
//  UserDefaultManager.swift
//  SUDATalk
//
//  Created by 김수경 on 11/27/24.
//

import Foundation

final class UserDefaultsManager {
    
    enum UserDefaultsKey: String {
        case profile
    }
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    @UserDefaultType(key: UserDefaultsKey.profile.rawValue, defaultValue: UserProfile(userID: "", email: ""))
    var userProfile: UserProfile
}

@propertyWrapper
struct UserDefaultType<T: Codable> {
    let key: String
    let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return defaultValue
            }
            let decodedValue = try? JSONDecoder().decode(T.self, from: data)
            return decodedValue ?? defaultValue
        }
        set {
            let encodedData = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.setValue(encodedData, forKey: key)
        }
    }
}
