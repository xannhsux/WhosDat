import SwiftUI
import CoreData

struct ContactListView: View {
    @EnvironmentObject var contactManager: ContactManager
    @State private var showingAddContact = false
    @State private var showingFilters = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SearchBar(text: $contactManager.searchText)
                
                // Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(
                            title: "All Roles",
                            isSelected: contactManager.selectedRole == nil,
                            action: { contactManager.selectedRole = nil }
                        )
                        
                        ForEach(contactManager.uniqueRoles, id: \.self) { role in
                            FilterChip(
                                title: role,
                                isSelected: contactManager.selectedRole == role,
                                action: { contactManager.selectedRole = role }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(
                            title: "All Connections",
                            isSelected: contactManager.selectedConnection == nil,
                            action: { contactManager.selectedConnection = nil }
                        )
                        
                        ForEach(contactManager.uniqueConnections, id: \.self) { connection in
                            FilterChip(
                                title: connection,
                                isSelected: contactManager.selectedConnection == connection,
                                action: { contactManager.selectedConnection = connection }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Contacts List
                List {
                    ForEach(contactManager.filteredContacts, id: \.objectID) { contact in
                        NavigationLink(destination: ContactDetailView(contact: contact)) {
                            ContactRowView(contact: contact)
                        }
                    }
                    .onDelete(perform: deleteContacts)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("My Network")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddContact = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddContact) {
                AddEditContactView()
                    .environmentObject(contactManager)
            }
        }
    }
    
    private func deleteContacts(offsets: IndexSet) {
        for index in offsets {
            let contact = contactManager.filteredContacts[index]
            contactManager.deleteContact(contact)
        }
    }
}

struct ContactRowView: View {
    let contact: NetworkContact
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(contact.name ?? "Unknown")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let role = contact.role {
                    Text(role)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
            }
            
            if let company = contact.company {
                Text(company)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let connection = contact.connection {
                Text(connection)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search contacts...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

#Preview {
    ContactListView()
        .environmentObject(ContactManager())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

