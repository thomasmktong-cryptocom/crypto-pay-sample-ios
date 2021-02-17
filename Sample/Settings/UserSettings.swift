//
//  UserSettings.swift
//  Sample
//
//  Created by Thomas Tong on 9/2/2021.
//

import Foundation
import Combine

class UserSettings: ObservableObject {
    
    @Published var payServerHost: String {
        didSet {
            UserDefaults.standard.set(payServerHost, forKey: "username")
        }
    }
    
    @Published var secretKey: String {
        didSet {
            UserDefaults.standard.set(secretKey, forKey: "secretKey")
        }
    }
    
    init() {
        self.payServerHost = UserDefaults.standard.object(forKey: "payServerHost") as? String ?? "pay.crypto.com"
        self.secretKey = UserDefaults.standard.object(forKey: "secretKey") as? String ?? "sk_test/live_XXX"
    }
}
