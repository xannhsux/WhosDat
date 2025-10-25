import SwiftUI

struct ContactDetailView: View {
    @EnvironmentObject var contactManager: ContactManager
    @State private var showingEditView = false
    
    let contact: NetworkContact
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(contact.name ?? "Unknown")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if let company = contact.company {
                        Text(company)
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    
                    if let role = contact.role {
                        Text(role)
                            .font(.headline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                    }
                }
                .padding(.bottom)
                
                // Basic Information
                if hasBasicInfo {
                    InfoSection(title: "Basic Information") {
                        InfoRow(label: "Education", value: contact.education)
                        InfoRow(label: "Connection", value: contact.connection)
                    }
                }
                
                // Contact Information
                if hasContactInfo {
                    InfoSection(title: "Contact Information") {
                        InfoRow(label: "Phone", value: contact.phone, isLink: true, linkType: .phone)
                        InfoRow(label: "Email", value: contact.email, isLink: true, linkType: .email)
                        InfoRow(label: "LinkedIn", value: contact.linkedin, isLink: true, linkType: .linkedin)
                        InfoRow(label: "Instagram", value: contact.instagram, isLink: true, linkType: .instagram)
                        InfoRow(label: "Twitter", value: contact.twitter, isLink: true, linkType: .twitter)
                    }
                }
                
                // Notes
                if let notes = contact.notes, !notes.isEmpty {
                    InfoSection(title: "Notes") {
                        Text(notes)
                            .font(.body)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                
                // Metadata
                InfoSection(title: "Metadata") {
                    InfoRow(label: "Added", value: formatDate(contact.dateAdded))
                    InfoRow(label: "Last Contact", value: formatDate(contact.lastContact))
                }
                
                Spacer(minLength: 100)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditView = true
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            AddEditContactView(contact: contact)
                .environmentObject(contactManager)
        }
    }
    
    private var hasBasicInfo: Bool {
        contact.education != nil || contact.connection != nil
    }
    
    private var hasContactInfo: Bool {
        contact.phone != nil || contact.email != nil || contact.linkedin != nil || 
        contact.instagram != nil || contact.twitter != nil
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Never" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct InfoSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            content
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct InfoRow: View {
    let label: String
    let value: String?
    let isLink: Bool
    let linkType: LinkType?
    
    enum LinkType {
        case phone, email, linkedin, instagram, twitter
    }
    
    init(label: String, value: String?, isLink: Bool = false, linkType: LinkType? = nil) {
        self.label = label
        self.value = value
        self.isLink = isLink
        self.linkType = linkType
    }
    
    var body: some View {
        if let value = value, !value.isEmpty {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(width: 80, alignment: .leading)
                
                if isLink {
                    Button(action: {
                        openLink(value, type: linkType)
                    }) {
                        Text(value)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.leading)
                    }
                } else {
                    Text(value)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
        }
    }
    
    private func openLink(_ value: String, type: LinkType?) {
        var urlString = value
        
        switch type {
        case .phone:
            urlString = "tel:\(value)"
        case .email:
            urlString = "mailto:\(value)"
        case .linkedin:
            if !value.hasPrefix("http") {
                urlString = "https://\(value)"
            }
        case .instagram:
            if !value.hasPrefix("http") {
                urlString = "https://instagram.com/\(value)"
            }
        case .twitter:
            if !value.hasPrefix("http") {
                urlString = "https://twitter.com/\(value)"
            }
        case .none:
            break
        }
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationView {
        ContactDetailView(contact: NetworkContact())
            .environmentObject(ContactManager())
    }
}
