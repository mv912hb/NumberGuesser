//
//  NumberGuesserApp.swift
//  NumberGuesser
//
//  Created by Boris Vedernikov on 02/09/2023.
//

import SwiftUI

@main
struct NumberGuesserApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
