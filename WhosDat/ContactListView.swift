import SwiftUI
import CoreData

struct ContactListView: View {
    @EnvironmentObject var contactManager: ContactManager
    @State private var showingAddContact = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Modern Search Bar
            SearchBar(text: $contactManager.searchText)
                .padding(.horizontal, 20)
                .padding(.top, 16)
            
            // Filter Chips
            if !contactManager.uniqueRoles.isEmpty || !contactManager.uniqueConnections.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterChip(
                            title: "All",
                            isSelected: contactManager.selectedRole == nil && contactManager.selectedConnection == nil,
                            action: { 
                                contactManager.selectedRole = nil
                                contactManager.selectedConnection = nil
                            }
                        )
                        
                        ForEach(contactManager.uniqueRoles, id: \.self) { role in
                            FilterChip(
                                title: role,
                                isSelected: contactManager.selectedRole == role,
                                action: { contactManager.selectedRole = role }
                            )
                        }
                        
                        ForEach(contactManager.uniqueConnections, id: \.self) { connection in
                            FilterChip(
                                title: connection,
                                isSelected: contactManager.selectedConnection == connection,
                                action: { contactManager.selectedConnection = connection }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 16)
            }
            
            // Modern Contacts List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(contactManager.filteredContacts, id: \.objectID) { contact in
                        NavigationLink(destination: ContactDetailView(contact: contact)) {
                            ContactCardView(contact: contact)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100) // Space for floating button
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAddContact) {
            AddEditContactView()
                .environmentObject(contactManager)
        }
    }
    
    private func deleteContacts(offsets: IndexSet) {
        for index in offsets {
            let contact = contactManager.filteredContacts[index]
            contactManager.deleteContact(contact)
        }
    }
}

struct ContactCardView: View {
    let contact: NetworkContact
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Professional Avatar Circle
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Text(String(contact.name?.prefix(1) ?? "?").uppercased())
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            // Contact Info
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(contact.name ?? "Unknown")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if let role = contact.role {
                        Text(role)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(12)
                    }
                }
                
                if let company = contact.company {
                    Text(company)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let connection = contact.connection {
                    HStack(spacing: 6) {
                        Image(systemName: "link.circle.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text(connection)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Arrow
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.black.opacity(0.05),
                    radius: 8,
                    x: 0,
                    y: 2
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

struct ContactRowView: View {
    let contact: NetworkContact
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(contact.name ?? "Unknown")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if let company = contact.company {
                        Text(company)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                if let role = contact.role {
                    Text(role)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
            }
            
            if let connection = contact.connection {
                HStack {
                    Image(systemName: "link")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(connection)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: 16, weight: .medium))
            
            TextField("Search your network...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.body)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
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
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? 
                    Color.blue :
                    Color(.systemGray5)
                )
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
                .shadow(
                    color: isSelected ? Color.blue.opacity(0.3) : Color.clear,
                    radius: 4,
                    x: 0,
                    y: 2
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    ContactListView()
        .environmentObject(ContactManager())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

