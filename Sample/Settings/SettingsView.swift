//
//  SettingsView.swift
//  Sample
//
//  Created by Thomas Tong on 9/2/2021.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var userSettings: UserSettings
    
    init(userSettings: UserSettings) {
        self.userSettings = userSettings
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Pay Server Host")) {
                    TextField("Pay Server Host", text: $userSettings.payServerHost)
                }
                
                Section(header: Text("Private Key")) {
                    TextField("Private Key", text: $userSettings.secretKey)
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarHidden(true)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(userSettings: UserSettings())
    }
}
