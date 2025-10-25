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
    @State private var birthday: Date = Date()
    @State private var ethnicity: String = ""
    @State private var nationality: String = ""
    @State private var hasBirthday: Bool = false
    
    // Predefined options for dropdowns
    private let roleOptions = ["VC", "PE", "Founder", "Big Name", "Professor", "Engineer", "Designer", "Marketing", "Sales", "Executive", "Manager", "Other"]
    private let connectionOptions = ["LinkedIn", "Alumni", "Classmate", "Friends", "Networking Event", "Conference", "Meetup", "Referral", "Work", "Other"]
    private let ethnicityOptions = ["Asian", "Black", "Hispanic", "White", "Middle Eastern", "Native American", "Pacific Islander", "Mixed", "Other", "Prefer not to say"]
    private let nationalityOptions = ["American", "Canadian", "British", "German", "French", "Chinese", "Japanese", "Korean", "Indian", "Australian", "Brazilian", "Mexican", "Other"]
    
    init(contact: NetworkContact? = nil) {
        self.contact = contact
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Section
                        VStack(spacing: 16) {
                            // Professional Avatar Placeholder
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.blue)
                            }
                            
                            Text(contact == nil ? "Add New Contact" : "Edit Contact")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        .padding(.top, 20)
                        
                        // Form Sections
                        VStack(spacing: 20) {
                            // Basic Information Section
                            FormSection(title: "Basic Information", icon: "person.fill") {
                                VStack(spacing: 16) {
                                    CustomTextField(title: "Full Name *", text: $name, placeholder: "Enter full name")
                                    
                                    CustomTextField(title: "Company", text: $company, placeholder: "Company name")
                                    
                                    CustomPicker(title: "Role", selection: $role, options: roleOptions)
                                    
                                    CustomTextField(title: "Education", text: $education, placeholder: "University, degree, etc.")
                                    
                                    CustomPicker(title: "Connection Type", selection: $connection, options: connectionOptions)
                                }
                            }
                            
                            // Personal Information Section
                            FormSection(title: "Personal Information", icon: "calendar") {
                                VStack(spacing: 16) {
                                    Toggle("Add Birthday", isOn: $hasBirthday)
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                    
                                    if hasBirthday {
                                        DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
                                            .datePickerStyle(CompactDatePickerStyle())
                                    }
                                    
                                    CustomPicker(title: "Ethnicity", selection: $ethnicity, options: ethnicityOptions)
                                    
                                    CustomPicker(title: "Nationality", selection: $nationality, options: nationalityOptions)
                                }
                            }
                            
                            // Contact Information Section
                            FormSection(title: "Contact Information", icon: "phone.fill") {
                                VStack(spacing: 16) {
                                    CustomTextField(title: "Phone", text: $phone, placeholder: "+1 (555) 123-4567", keyboardType: .phonePad)
                                    
                                    CustomTextField(title: "Email", text: $email, placeholder: "email@company.com", keyboardType: .emailAddress)
                                    
                                    CustomTextField(title: "LinkedIn", text: $linkedin, placeholder: "linkedin.com/in/username")
                                    
                                    CustomTextField(title: "Instagram", text: $instagram, placeholder: "@username")
                                    
                                    CustomTextField(title: "Twitter", text: $twitter, placeholder: "@username")
                                }
                            }
                            
                            // Notes Section
                            FormSection(title: "Additional Notes", icon: "note.text") {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Notes")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    
                                    TextField("Meeting notes, interests, follow-up reminders...", text: $notes, axis: .vertical)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding(12)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                        .lineLimit(3...6)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveContact()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(name.isEmpty ? .gray : .blue)
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
        ethnicity = contact.ethnicity ?? ""
        nationality = contact.nationality ?? ""
        
        if let birthday = contact.birthday {
            self.birthday = birthday
            hasBirthday = true
        }
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
                notes: notes.isEmpty ? nil : notes,
                birthday: hasBirthday ? birthday : nil,
                ethnicity: ethnicity.isEmpty ? nil : ethnicity,
                nationality: nationality.isEmpty ? nil : nationality
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
                notes: notes.isEmpty ? nil : notes,
                birthday: hasBirthday ? birthday : nil,
                ethnicity: ethnicity.isEmpty ? nil : ethnicity,
                nationality: nationality.isEmpty ? nil : nationality
            )
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct FormSection<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.subheadline)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            
            content
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .keyboardType(keyboardType)
                .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
}

struct CustomPicker: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        selection = option
                    }
                }
            } label: {
                HStack {
                    Text(selection.isEmpty ? "Select \(title.lowercased())" : selection)
                        .foregroundColor(selection.isEmpty ? .secondary : .primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
    }
}

#Preview {
    AddEditContactView()
        .environmentObject(ContactManager())
}
