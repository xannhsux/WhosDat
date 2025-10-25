import SwiftUI

struct ContentView: View {
    var body: some View {
        ContactListView()
    }
}

#Preview {
    ContentView()
        .environmentObject(ContactManager())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
