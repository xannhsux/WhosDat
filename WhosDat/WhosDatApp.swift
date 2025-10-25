import SwiftUI

@main
struct WhosDatApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var contactManager = ContactManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(contactManager)
        }
    }
}
