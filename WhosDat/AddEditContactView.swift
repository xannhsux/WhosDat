import SwiftUI

struct AddEditContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var contactManager: ContactManager
    
    let contact: NetworkContact?
    
    @State private var name: String = ""
    @State private var company: String = ""
    @State private var role: String = ""
    @State private var education: String = ""
    @State private var connection: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var linkedin: String = ""
    @State private var instagram: String = ""
    @State private var twitter: String = ""
    @State private var notes: String = ""
    
    // Predefined options for dropdowns
    private let roleOptions = ["VC", "PE", "Founder", "Big Name", "Professor", "Engineer", "Designer", "Marketing", "Sales", "Other"]
    private let connectionOptions = ["LinkedIn", "Alumni", "Classmate", "Friends", "Networking Event", "Conference", "Meetup", "Referral", "Other"]
    
    init(contact: NetworkContact? = nil) {
        self.contact = contact
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Name *", text: $name)
                    TextField("Company", text: $company)
                    
                    Picker("Role", selection: $role) {
                        Text("Select Role").tag("")
                        ForEach(roleOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    
                    TextField("Education", text: $education)
                    
                    Picker("Connection", selection: $connection) {
                        Text("Select Connection").tag("")
                        ForEach(connectionOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                }
                
                Section(header: Text("Contact Information")) {
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("LinkedIn", text: $linkedin)
                        .autocapitalization(.none)
                    TextField("Instagram", text: $instagram)
                        .autocapitalization(.none)
                    TextField("Twitter", text: $twitter)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Notes")) {
                    TextField("Additional notes...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(contact == nil ? "Add Contact" : "Edit Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveContact()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
        .onAppear {
            if let contact = contact {
                loadContactData(contact)
            }
        }
    }
    
    private func loadContactData(_ contact: NetworkContact) {
        name = contact.name ?? ""
        company = contact.company ?? ""
        role = contact.role ?? ""
        education = contact.education ?? ""
        connection = contact.connection ?? ""
        phone = contact.phone ?? ""
        email = contact.email ?? ""
        linkedin = contact.linkedin ?? ""
        instagram = contact.instagram ?? ""
        twitter = contact.twitter ?? ""
        notes = contact.notes ?? ""
    }
    
    private func saveContact() {
        if let contact = contact {
            // Update existing contact
            contactManager.updateContact(
                contact,
                name: name,
                company: company.isEmpty ? nil : company,
                role: role.isEmpty ? nil : role,
                education: education.isEmpty ? nil : education,
                connection: connection.isEmpty ? nil : connection,
                phone: phone.isEmpty ? nil : phone,
                email: email.isEmpty ? nil : email,
                linkedin: linkedin.isEmpty ? nil : linkedin,
                instagram: instagram.isEmpty ? nil : instagram,
                twitter: twitter.isEmpty ? nil : twitter,
                notes: notes.isEmpty ? nil : notes
            )
        } else {
            // Add new contact
            contactManager.addContact(
                name: name,
                company: company.isEmpty ? nil : company,
                role: role.isEmpty ? nil : role,
                education: education.isEmpty ? nil : education,
                connection: connection.isEmpty ? nil : connection,
                phone: phone.isEmpty ? nil : phone,
                email: email.isEmpty ? nil : email,
                linkedin: linkedin.isEmpty ? nil : linkedin,
                instagram: instagram.isEmpty ? nil : instagram,
                twitter: twitter.isEmpty ? nil : twitter,
                notes: notes.isEmpty ? nil : notes
            )
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddEditContactView()
        .environmentObject(ContactManager())
}
